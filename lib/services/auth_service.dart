import 'menu_storage_service.dart';

class AuthService {
  final MenuStorageService _s = MenuStorageService();

  Future<void> register({
    required String name,
    required String phone,
    String email = '',
    required String password,
  }) async {
    await _s.setString(StorageKeys.name, name.trim());
    await _s.setString(StorageKeys.phone, phone.trim());
    if (email.trim().isNotEmpty) {
      await _s.setString(StorageKeys.email, email.trim());
    } else {
      await _s.remove(StorageKeys.email);
    }
    await _s.setString(StorageKeys.authPassword, password);

    // Akun baru: buang sisa foto dan birthday dari akun sebelumnya.
    await _s.remove(StorageKeys.imagePath);
    await _s.remove(StorageKeys.birthday);

    await _s.setBool(StorageKeys.authLoggedIn, true);
  }

  Future<void> registerWithId({
    required String identifier,
    required String password,
  }) async {
    final id = identifier.trim();
    for (final k in [
      StorageKeys.name,
      StorageKeys.phone,
      StorageKeys.email,
      StorageKeys.imagePath,
      StorageKeys.birthday,
    ]) {
      await _s.remove(k);
    }
    if (id.contains('@')) {
      await _s.setString(StorageKeys.email, id);
    } else {
      await _s.setString(StorageKeys.phone, id);
    }
    await _s.setString(StorageKeys.authPassword, password);
    await _s.setBool(StorageKeys.authLoggedIn, false);
  }

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    final id = identifier.trim();
    final phone = await _s.getString(StorageKeys.phone, '');
    final email = await _s.getString(StorageKeys.email, '');
    final savedPw = await _s.getString(StorageKeys.authPassword, '');

    final idOk = id.isNotEmpty &&
        (id == phone || (email.isNotEmpty && id.toLowerCase() == email.toLowerCase()));
    final ok = savedPw.isNotEmpty && idOk && password == savedPw;
    if (ok) await _s.setBool(StorageKeys.authLoggedIn, true);
    return ok;
  }

  Future<bool> isLoggedIn() => _s.getBool(StorageKeys.authLoggedIn, false);

  Future<bool> verifyPassword(String input) async {
    final saved = await _s.getString(StorageKeys.authPassword, '');
    if (saved.isEmpty) return true;
    return input == saved;
  }

  Future<void> changePassword(String newPassword) =>
      _s.setString(StorageKeys.authPassword, newPassword);

  Future<void> logout() => _s.setBool(StorageKeys.authLoggedIn, false);
}