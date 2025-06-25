import 'package:flutter/material.dart';

/// صفحة "إدارة المستخدمين" متكاملة للاستخدام داخل مشروع Flutter حقيقي
/// احفظ الملف في `lib/pages/user_management_page.dart` وسجّل المسار في `main.dart`.

enum UserRole { admin, manager, technician, assistant }

/// نموذج بيانات المستخدم
class User {
  int id;
  String username;
  UserRole role;
  bool isActive;

  User({
    required this.id,
    required this.username,
    required this.role,
    this.isActive = true,
  });
}

class UserManagementPage extends StatefulWidget {
  static const String routeName = '/user-management';
  final UserRole role;

  const UserManagementPage({Key? key, required this.role}) : super(key: key);

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final List<User> _allUsers = [
    User(id: 1, username: 'eng ali', role: UserRole.admin),
    User(id: 2, username: 'manager1', role: UserRole.manager),
    User(id: 3, username: 'tech1', role: UserRole.technician),
    User(id: 4, username: 'assist1', role: UserRole.assistant),
  ];
  String _searchQuery = '';
  UserRole? _filterRole;
  int _nextId = 5;

  List<User> get _filteredUsers =>
      _allUsers.where((u) {
        final matchesSearch = u.username.contains(_searchQuery);
        final matchesRole = _filterRole == null || u.role == _filterRole;
        return matchesSearch && matchesRole;
      }).toList();

  void _showAddEditDialog({User? user}) {
    final isEdit = user != null;
    final usernameCtrl = TextEditingController(text: user?.username);
    final passwordCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    UserRole? selectedRole = user?.role;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(isEdit ? 'تعديل مستخدم' : 'إضافة مستخدم'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: usernameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'اسم المستخدم',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'تأكيد كلمة المرور',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<UserRole>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'الصلاحية',
                    border: OutlineInputBorder(),
                  ),
                  items: UserRole.values.map((r) {
                    return DropdownMenuItem(
                      value: r,
                      child: Text(r.name),
                    );
                  }).toList(),
                  onChanged: (v) => selectedRole = v,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final uname = usernameCtrl.text.trim();
                final pwd = passwordCtrl.text;
                final conf = confirmCtrl.text;
                if (uname.isEmpty || pwd.isEmpty || pwd != conf || selectedRole == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('يرجى ملء جميع الحقول بشكل صحيح')),
                  );
                  return;
                }
                setState(() {
                  if (isEdit) {
                    user!
                      ..username = uname
                      ..role = selectedRole!;
                  } else {
                    _allUsers.add(User(
                      id: _nextId++,
                      username: uname,
                      role: selectedRole!,
                    ));
                  }
                });
                Navigator.pop(ctx);
              },
              child: Text(isEdit ? 'حفظ' : 'إضافة'),
            ),
          ],
        );
      },
    );
  }

  void _resetPassword(User user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعادة تعيين كلمة المرور'),
        content: Text('هل أنت متأكد من إعادة تعيين كلمة المرور لـ ${user.username}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم إعادة تعيين كلمة المرور لـ ${user.username} إلى 123456')),
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.role == UserRole.technician || widget.role == UserRole.assistant) {
      return Scaffold(
        appBar: AppBar(title: const Text('إدارة المستخدمين')),
        body: const Center(child: Text('غير مصرح بالدخول')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المستخدمين')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'بحث',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<UserRole?>(
                  value: _filterRole,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('كل الصلاحيات')),
                    ...UserRole.values.map((r) => DropdownMenuItem(value: r, child: Text(r.name))),
                  ],
                  onChanged: (v) => setState(() => _filterRole = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (ctx, i) {
                  final u = _filteredUsers[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(u.username),
                      subtitle: Text('الصلاحية: ${u.role.name}'),
                      leading: Text('${u.id}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showAddEditDialog(user: u),
                          ),
                          IconButton(
                            icon: Icon(u.isActive ? Icons.block : Icons.check),
                            onPressed: () => setState(() => u.isActive = !u.isActive),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () => _resetPassword(u),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: (widget.role == UserRole.admin || widget.role == UserRole.manager)
          ? FloatingActionButton(
              onPressed: () => _showAddEditDialog(),
              child: const Icon(Icons.add),
              tooltip: 'إضافة مستخدم',
            )
          : null,
    );
  }
}

// ------------------------ main.dart ------------------------

void main() {
  runApp(const UserManagementApp());
}

class UserManagementApp extends StatelessWidget {
  const UserManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // جرّب تغيير الدور هنا
    const currentRole = UserRole.admin;
    return MaterialApp(
      title: 'إدارة المستخدمين',
      debugShowCheckedModeBanner: false,
      initialRoute: UserManagementPage.routeName,
      routes: {
        UserManagementPage.routeName: (_) => const UserManagementPage(role: currentRole),
      },
    );
  }
}
