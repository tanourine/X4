import 'package:flutter/material.dart';

/// صفحة الإعدادات الجاهزة للاستخدام
/// ضع هذا الملف تحت `lib/pages/settings_page.dart` وسجّل مساره في `main.dart`.

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // بيانات الحساب
  String _userName = 'John Doe';
  String _userEmail = 'johndoe@example.com';

  // الإشعارات
  bool _dailyReminders = false;
  bool _rem8pm = false;
  bool _rem9pm = false;
  bool _rem10pm = false;
  bool _rem11pm = false;
  bool _pushNotifications = true;
  bool _inAppNotifications = true;

  // التفضيلات
  String _language = 'العربية';
  final List<String> _languages = ['العربية', 'English'];
  String _theme = 'System Default';

  // تغيير كلمة المرور
  final _currentPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _editProfile() async {
    // TODO: ربط صفحة تعديل الملف الشخصي
    _showSnack('Edit Profile tapped');
  }

  Future<void> _changePassword() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Password (تغيير كلمة المرور)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            TextField(
              controller: _newPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              controller: _confirmPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (_newPassCtrl.text != _confirmPassCtrl.text) {
                _showSnack('New passwords do not match');
                return;
              }
              Navigator.pop(ctx);
              _showSnack('Password changed successfully');
              _currentPassCtrl.clear();
              _newPassCtrl.clear();
              _confirmPassCtrl.clear();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _contactSupport() async {
    // TODO: ربط صفحة الدعم
    _showSnack('Contact Support tapped');
  }

  Future<void> _showTerms() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Terms & Privacy'),
        content: const Text('Terms and Privacy content goes here...'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings (الإعدادات)')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // قسم الحساب
            const Text('Account (الحساب)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(_userName),
              subtitle: Text(_userEmail),
              trailing: IconButton(icon: const Icon(Icons.edit), onPressed: _editProfile),
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password (تغيير كلمة المرور)'),
              onTap: _changePassword,
            ),
            const Divider(height: 32),

            // قسم الإشعارات
            const Text('Notifications (الإشعارات)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Daily Reminders (التذكيرات اليومية)'),
              value: _dailyReminders,
              onChanged: (v) => setState(() => _dailyReminders = v),
            ),
            if (_dailyReminders) ...[
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Column(children: [
                  SwitchListTile(
                    title: const Text('8:00 PM'),
                    value: _rem8pm,
                    onChanged: (v) => setState(() => _rem8pm = v),
                  ),
                  SwitchListTile(
                    title: const Text('9:00 PM'),
                    value: _rem9pm,
                    onChanged: (v) => setState(() => _rem9pm = v),
                  ),
                  SwitchListTile(
                    title: const Text('10:00 PM'),
                    value: _rem10pm,
                    onChanged: (v) => setState(() => _rem10pm = v),
                  ),
                  SwitchListTile(
                    title: const Text('11:00 PM'),
                    value: _rem11pm,
                    onChanged: (v) => setState(() => _rem11pm = v),
                  ),
                ]),
              ),
            ],
            SwitchListTile(
              title: const Text('Push Notifications (إشعارات الدفع)'),
              value: _pushNotifications,
              onChanged: (v) => setState(() => _pushNotifications = v),
            ),
            SwitchListTile(
              title: const Text('In-App Notifications (الإشعارات داخل التطبيق)'),
              value: _inAppNotifications,
              onChanged: (v) => setState(() => _inAppNotifications = v),
            ),
            const Divider(height: 32),

            // قسم التفضيلات
            const Text('Preferences (التفضيلات)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Language (اللغة)'),
              value: _language,
              items: _languages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
              onChanged: (v) => setState(() => _language = v!),
            ),
            const SizedBox(height: 12),
            const Text('Theme (الثيم)', style: TextStyle(fontSize: 16)),
            RadioListTile<String>(
              title: const Text('Light'),
              value: 'Light',
              groupValue: _theme,
              onChanged: (v) => setState(() => _theme = v!),
            ),
            RadioListTile<String>(
              title: const Text('Dark'),
              value: 'Dark',
              groupValue: _theme,
              onChanged: (v) => setState(() => _theme = v!),
            ),
            RadioListTile<String>(
              title: const Text('System Default'),
              value: 'System Default',
              groupValue: _theme,
              onChanged: (v) => setState(() => _theme = v!),
            ),
            const Divider(height: 32),

            // قسم الدعم والمعلومات
            const Text('Help & About (الدعم والمعلومات)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text('Contact Support (تواصل مع الدعم)'),
              onTap: _contactSupport,
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Terms & Privacy (الشروط والخصوصية)'),
              onTap: _showTerms,
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('App Version (إصدار التطبيق)'),
              trailing: const Text('v1.0.0'),
            ),
            const Divider(height: 32),

            // إجراءات الحساب
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => _showSnack('Logged out'),
              child: const Text('Logout (تسجيل الخروج)'),
            ),
          ],
        ),
      ),
    );
  }
}
