import 'package:flutter/material.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_header.dart';
import 'widgets/input.dart';
import 'widgets/password.dart';
import 'widgets/auth_tabs.dart';
import 'auth_session.dart';
import '../services/menu_storage_service.dart';

class AuthScreen extends StatefulWidget {
  final bool isLoginAwal;
  
  const AuthScreen({super.key, this.isLoginAwal = true});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();

  late bool _isLogin = widget.isLoginAwal;

  @override
  void dispose() {
    _idController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _cekId(String? nilai) {
    final isi = nilai?.trim() ?? '';
    if (isi.isEmpty) return 'Email / nomor HP wajib diisi';
    
    final email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$').hasMatch(isi);
    final hp = RegExp(r'^\+?[0-9]{9,15}$').hasMatch(isi);
    
    if (!email && !hp) return 'Isi dengan email atau nomor HP yang valid';
    return null;
  }

   String? _cekPassword(String? nilai) {
    if (nilai == null || nilai.isEmpty) return 'Password wajib diisi';

    if (nilai.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  String? _cekKonfirmasi(String? nilai) {
    if (nilai != _passController.text) return 'Password tidak sama';
    return null;
  }


    Future<void> _submit() async {

    if (!_formKey.currentState!.validate()) return;

    if (_isLogin) {

      await MenuStorageService()
          .setString(StorageKeys.phone, _idController.text.trim());
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(context, '/menu', (route) => false);
    } 
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun berhasil dibuat, silakan login')),
      );
      _passController.clear();
      _confirmController.clear();
      setState(() => _isLogin = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
           child: Form(
            key: _formKey,
            child: Column(
              children: [
                const AuthHeader(
                  title: 'GetContact',
                  subtitle: 'Temukan dan kelola kontakmu dengan mudah',
                ),
                const SizedBox(height: 24),
                AuthTabs(
                  isLogin: _isLogin,
                  onChanged: (nilai) {
                    _formKey.currentState?.reset(); // hapus pesan error lama
                    setState(() => _isLogin = nilai);
                },
              ),
              const SizedBox(height: 24),
              Input(
                  controller: _idController,
                  label: 'Email / No. HP',
                  hint: 'contoh@email.com atau 08123456789',
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: _cekId,
                ),
              const SizedBox(height: 24),
              Password(
                  controller: _passController,
                  validator: _cekPassword,
                ),

                if (!_isLogin) ...[
                  const SizedBox(height: 16),
                  Password(
                    controller: _confirmController,
                    label: 'Konfirmasi Password',
                    validator: _cekKonfirmasi,
                  ),
                ],
                const SizedBox(height: 28),
                AuthButton(
                  label: _isLogin ? 'Login' : 'Sign Up',
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}