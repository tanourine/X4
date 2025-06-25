// lib/widgets/drawer_menu.dart

import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/upload_invoice_page.dart';
import '../pages/project_invoice_page.dart';
// لا تستورد هنا الصفحات غير الموجودة بعد

class DrawerMenu extends StatelessWidget {
  final String username;
  final UserRole role;
  const DrawerMenu({super.key, required this.username, required this.role});

  @override
  Widget build(BuildContext ctx) {
    final items = <_MenuItem>[];

    if (role == UserRole.admin) {
      items.addAll([
        _MenuItem('الرئيسية', Icons.home, '/home'),
        _MenuItem('تحميل فواتير المشاريع', Icons.receipt, '/project-invoice'),
        // أضف هنا باقي البنود عند تجهيز الصفحات
        _MenuItem('الإعدادات', Icons.settings, '/settings'),
      ]);
    }

    if (role == UserRole.maintenanceManager) {
      items.addAll([
        _MenuItem('الرئيسية', Icons.home, '/home'),
        _MenuItem('تحميل فواتير', Icons.attach_money, '/upload-invoice'),
        _MenuItem('الإعدادات', Icons.settings, '/settings'),
      ]);
    }

    if (role == UserRole.technician) {
      items.addAll([
        _MenuItem('الرئيسية', Icons.home, '/home'),
        _MenuItem('تحميل فواتير', Icons.attach_money, '/upload-invoice'),
        _MenuItem('الإعدادات', Icons.settings, '/settings'),
      ]);
    }

    if (role == UserRole.assistant) {
      items.addAll([
        _MenuItem('الرئيسية', Icons.home, '/home'),
        _MenuItem('تحميل فواتير', Icons.attach_money, '/upload-invoice'),
        _MenuItem('الإعدادات', Icons.settings, '/settings'),
      ]);
    }

    items.add(_MenuItem('تسجيل الخروج', Icons.logout, '/'));

    return Drawer(
      child: SafeArea(
        child: ListView(
          children: items.map((it) {
            return ListTile(
              leading: Icon(it.icon),
              title: Text(it.title),
              onTap: () {
                Navigator.pop(ctx);
                if (it.route == '/') {
                  Navigator.pushReplacementNamed(ctx, it.route);
                } else {
                  Navigator.pushNamed(ctx, it.route);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final String route;
  _MenuItem(this.title, this.icon, this.route);
}
