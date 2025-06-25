import 'package:flutter/material.dart';
import 'home_page.dart';

enum UserRole { admin, maintenanceManager, technician, assistant }

class LoginPage extends StatefulWidget {
  static const route = '/';
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _error;

  final _users = {
    'eng ali':    {'pass': '4229', 'role': UserRole.admin},
    'supervisor': {'pass': '1234', 'role': UserRole.maintenanceManager},
    'tech1':      {'pass': 'abcd', 'role': UserRole.technician},
    'tech2':      {'pass': 'efgh', 'role': UserRole.technician},
    'assistant1': {'pass': 'zzz1','role': UserRole.assistant},
  };

  void _login() {
    final u = _userCtrl.text.trim();
    final p = _passCtrl.text.trim();
    if (_users.containsKey(u) && _users[u]!['pass'] == p) {
      final role = _users[u]!['role'] as UserRole;
      Navigator.pushReplacementNamed(
        context,
        HomePage.route,
        arguments: {'username': u, 'role': role},
      );
    } else {
      setState(() => _error = 'بيانات خاطئة');
    }
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: _userCtrl,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _passCtrl,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          if (_error != null) ...[
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ),
        ]),
      ),
    );
  }
}
