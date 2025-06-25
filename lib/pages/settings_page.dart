import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _userName = 'John Doe', _userEmail = 'john@ex.com';
  bool _dailyRem = false, _push = true, _inApp = true;
  String _lang = 'العربية', _theme = 'System Default';
  final _languages = ['العربية', 'English'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Account', style: TextStyle(fontWeight: FontWeight.bold)),
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(_userName),
          subtitle: Text(_userEmail),
          trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        ),
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Change Password'),
          onTap: () {},
        ),
        const Divider(),

        const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        SwitchListTile(
            title: const Text('Daily Reminders'),
            value: _dailyRem,
            onChanged: (v) => setState(() => _dailyRem = v)),
        SwitchListTile(
            title: const Text('Push Notifications'),
            value: _push,
            onChanged: (v) => setState(() => _push = v)),
        SwitchListTile(
            title: const Text('In-App Notifications'),
            value: _inApp,
            onChanged: (v) => setState(() => _inApp = v)),
        const Divider(),

        const Text('Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Language'),
          value: _lang,
          items: _languages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
          onChanged: (v) => setState(() => _lang = v!),
        ),
        const SizedBox(height: 12),
        const Text('Theme'),
        RadioListTile(
            title: const Text('Light'),
            value: 'Light',
            groupValue: _theme,
            onChanged: (v) => setState(() => _theme = v!)),
        RadioListTile(
            title: const Text('Dark'),
            value: 'Dark',
            groupValue: _theme,
            onChanged: (v) => setState(() => _theme = v!)),
        RadioListTile(
            title: const Text('System Default'),
            value: 'System Default',
            groupValue: _theme,
            onChanged: (v) => setState(() => _theme = v!)),
        const Divider(),

        const Text('Help & About', style: TextStyle(fontWeight: FontWeight.bold)),
        ListTile(
          leading: const Icon(Icons.support_agent),
          title: const Text('Contact Support'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Terms & Privacy'),
          onTap: () {},
        ),
        ListTile(
            leading: const Icon(Icons.info),
            title: const Text('App Version'),
            trailing: const Text('v1.0.0')),
        const Divider(),

        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {},
          child: const Text('Logout'),
        ),
      ]),
    );
  }
}
