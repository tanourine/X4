import 'package:flutter/material.dart';
import 'login_page.dart';

class UserManagementPage extends StatefulWidget {
  static const route = '/user-management';
  const UserManagementPage({super.key});
  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final List<Map<String, dynamic>> _users = [
    {'username':'eng ali', 'role':UserRole.admin},
  ];

  void _showAddDialog() {
    final uCtrl = TextEditingController();
    final pCtrl = TextEditingController();
    UserRole? selRole;
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('إضافة مستخدم'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: uCtrl, decoration: const InputDecoration(labelText: 'Username')),
          TextField(controller: pCtrl, decoration: const InputDecoration(labelText: 'Password')),
          DropdownButton<UserRole>(
            hint: const Text('Role'),
            value: selRole,
            items: UserRole.values
                .map((r) => DropdownMenuItem(value: r, child: Text(r.toString().split('.').last)))
                .toList(),
            onChanged: (v) => selRole = v,
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          ElevatedButton(onPressed: () {
            if (uCtrl.text.trim().isEmpty || pCtrl.text.trim().isEmpty || selRole == null) return;
            setState(() {
              _users.add({'username':uCtrl.text.trim(), 'role':selRole});
            });
            Navigator.pop(c);
          }, child: const Text('Add')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المستخدمين')),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (_, i) {
          final u = _users[i];
          return ListTile(
            title: Text(u['username']),
            subtitle: Text(u['role'].toString().split('.').last),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => setState(() => _users.removeAt(i)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
