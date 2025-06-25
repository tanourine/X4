import 'package:flutter/material.dart';
import '../pages/login_page.dart';

class DrawerMenu extends StatelessWidget {
  final String username;
  final UserRole role;
  const DrawerMenu({super.key, required this.username, required this.role});

  @override
  Widget build(BuildContext context) {
    // بناء قائمة “المزيد” حسب الصلاحية
    final items = <Map<String, String>>[];

    // مشتركة: Home
    items.add({'label': 'Home', 'route': '/home'});
    if (role == UserRole.admin || role == UserRole.maintenanceManager) {
      items.add({'label': 'Upload Invoice', 'route': '/upload-invoice'});
      items.add({'label': 'Requests', 'route': '/reports'});
      items.add({'label': 'Equipment Check', 'route': '/equipment-check'});
      items.add({'label': 'Tools Reports', 'route': '/tools-reports'});
      items.add({'label': 'Schedule Tomorrow', 'route': '/schedule-tomorrow'});
    }
    items.add({'label': 'Settings', 'route': '/settings'});
    items.add({'label': 'Logout', 'route': LoginPage.routeName});

    return Drawer(
      child: SafeArea(
        child: ListView(
          children: items.map((it) {
            return ListTile(
              title: Text(it['label']!),
              onTap: () {
                Navigator.pop(context);
                if (it['label'] == 'Logout') {
                  Navigator.pushReplacementNamed(context, it['route']!);
                } else {
                  Navigator.pushNamed(context, it['route']!);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
