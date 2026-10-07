import 'package:shared_preferences/shared_preferences.dart';

/// Semua key penyimpanan dikumpulkan di sini supaya tidak typo.
class StorageKeys {
  // Profile
  static const name = 'profile_name';
  static const phone = 'profile_phone';
  static const imagePath = 'profile_image_path';
  static const birthday = 'profile_birthday';

  // Protection
  static const protectionOn = 'protection_on';
  static const blockSpamCall = 'protection_block_call';
  static const blockSpamSms = 'protection_block_sms';
  static const showUnknownId = 'protection_unknown_id';

  // Notifications
  static const notifPush = 'notif_push';
  static const notifViewed = 'notif_viewed';
  static const notifTags = 'notif_tags';
  static const notifChat = 'notif_chat';
  static const notifPromo = 'notif_promo';

  // Shortcuts
  static const scSearch = 'shortcut_search';
  static const scCopy = 'shortcut_copy';
  static const scBlock = 'shortcut_block';
  static const scTag = 'shortcut_tag';
  static const scNotifBar = 'shortcut_notifbar';

  // Account
  static const email = 'account_email';
}

class MenuStorageService {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<String> getString(String key, String defaultValue) async =>
      (await _prefs).getString(key) ?? defaultValue;

  Future<String?> getStringOrNull(String key) async =>
      (await _prefs).getString(key);

  Future<void> setString(String key, String value) async =>
      (await _prefs).setString(key, value);

  Future<bool> getBool(String key, bool defaultValue) async =>
      (await _prefs).getBool(key) ?? defaultValue;

  Future<void> setBool(String key, bool value) async =>
      (await _prefs).setBool(key, value);

  Future<void> remove(String key) async => (await _prefs).remove(key);

  Future<void> clearAll() async => (await _prefs).clear();
}
