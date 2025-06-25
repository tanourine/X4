import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/upload_invoice_page.dart';
import '../pages/project_invoice_page.dart';
import '../pages/equipment_setup_page.dart';
import '../pages/equipment_check_page.dart';
import '../pages/tools_reports_page.dart';
import '../pages/schedule_tomorrow_page.dart';
import '../pages/maintenance_requests_review_page.dart';
import '../pages/request_page.dart';
import '../pages/money_requests_review_page.dart';
import '../pages/user_management_page.dart';
import '../pages/export_reports_page.dart';
import '../pages/attendance_page.dart';
import '../pages/settings_page.dart';
import '../pages/login_page.dart';

class DrawerMenu extends StatelessWidget {
  final String username;
  final UserRole role;
  const DrawerMenu({super.key, required this.username, required this.role});

  @override
  Widget build(BuildContext ctx) {
    final items = <_MenuItem>[];

    // Admin
    if (role == UserRole.admin) {
      items.addAll([
        _MenuItem('الرئيسية', Icons.home, HomePage.route),
        _MenuItem('تحميل فواتير المشاريع', Icons.receipt, ProjectInvoicePage.route),
        _MenuItem('تقارير العدة والأدوات', Icons.report, ToolsReportsPage.route),
        _MenuItem('إدارة المستخدمين', Icons.people, UserManagementPage.route),
        _MenuItem('مراجعة طلبات الأموال', Icons.money, MoneyRequestsReviewPage.route),
        _MenuItem('توليد ملفات', Icons.file_download, ExportReportsPage.route),
        _MenuItem('العدة والأدوات', Icons.build, EquipmentSetupPage.route),
        _MenuItem('تحديد موعد الدوام غداً', Icons.calendar_today, ScheduleTomorrowPage.route),
        _MenuItem('مراجعة طلبات الصيانة', Icons.build_circle, MaintenanceRequestsReviewPage.route),
        _MenuItem('الإعدادات', Icons.settings, SettingsPage.route),
      ]);
    }

    // Supervisor
    if (role == UserRole.maintenanceManager) {
      items.addAll([
        _MenuItem('الرئيسية', Icons.home, HomePage.route),
        _MenuItem('تحميل فواتير', Icons.attach_money, UploadInvoicePage.route),
        _MenuItem('تقارير العدة والأدوات', Icons.report, ToolsReportsPage.route),
        _MenuItem('العدة والأدوات', Icons.build, EquipmentSetupPage.route),
        _MenuItem('تحديد موعد الدوام غداً', Icons.calendar_today, ScheduleTomorrowPage.route),
        _MenuItem('مراجعة طلبات الصيانة', Icons.build_circle, MaintenanceRequestsReviewPage.route),
        _MenuItem('الإعدادات', Icons.settings, SettingsPage.route),
      ]);
    }

    // Technician
    if (role == UserRole.technician) {
      items.addAll([
        _MenuItem('الرئيسية', Icons.home, HomePage.route),
        _MenuItem('تحميل فواتير', Icons.attach_money, UploadInvoicePage.route),
        _MenuItem('طلبات الصيانة', Icons.build_circle, MaintenanceRequestsReviewPage.route),
        _MenuItem('تشييك العدة', Icons.handyman, EquipmentCheckPage.route),
        _MenuItem('الإعدادات', Icons.settings, SettingsPage.route),
      ]);
    }

    // Assistant
    if (role == UserRole.assistant) {
      items.addAll([
        _MenuItem('الرئيسية', Icons.home, HomePage.route),
        _MenuItem('تحميل فواتير', Icons.attach_money, UploadInvoicePage.route),
        _MenuItem('الإعدادات', Icons.settings, SettingsPage.route),
      ]);
    }

    // Common Logout
    items.add(_MenuItem('تسجيل الخروج', Icons.logout, LoginPage.route));

    return Drawer(
      child: SafeArea(
        child: ListView(
          children: items.map((it) {
            return ListTile(
              leading: Icon(it.icon),
              title: Text(it.title),
              onTap: () {
                Navigator.pop(ctx);
                if (it.route == LoginPage.route) {
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
