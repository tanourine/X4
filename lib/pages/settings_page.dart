import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static const route = '/settings';
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _dailyRem = true, _push = true, _inApp = true;
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(children: [
        const ListTile(title: Text('Account', style: TextStyle(fontWeight: FontWeight.bold))),
        ListTile(title: const Text('Edit Profile'), onTap: () {}),
        ListTile(title: const Text('Change Password'), onTap: () {}),
        const Divider(),
        const ListTile(title: Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold))),
        SwitchListTile(
          title: const Text('Daily Reminders'), value: _dailyRem,
          onChanged: (v) => setState(() => _dailyRem = v),
        ),
        SwitchListTile(
          title: const Text('Push Notifications'), value: _push,
          onChanged: (v) => setState(() => _push = v),
        ),
        SwitchListTile(
          title: const Text('In-App Notifications'), value: _inApp,
          onChanged: (v) => setState(() => _inApp = v),
        ),
        const Divider(),
        const ListTile(title: Text('Preferences', style: TextStyle(fontWeight: FontWeight.bold))),
        ListTile(title: const Text('Language'), onTap: () {}),
        ListTile(title: const Text('Theme'), onTap: () {}),
        const Divider(),
        const ListTile(title: Text('Help & About', style: TextStyle(fontWeight: FontWeight.bold))),
        ListTile(title: const Text('Contact Support'), onTap: () {}),
        ListTile(title: const Text('Terms & Privacy'), onTap: () {}),
        ListTile(title: const Text('App Version: 1.0.0'), onTap: () {}),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () => Navigator.pushReplacementNamed(ctx, '/'),
        ),
      ]),
    );
  }
}
