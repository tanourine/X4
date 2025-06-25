import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/upload_invoice_page.dart';
import '../pages/project_invoice_page.dart';
import '../pages/tools_reports_page.dart';
import '../pages/user_management_page.dart';
import '../pages/money_requests_review_page.dart';
import '../pages/export_reports_page.dart';
import '../pages/equipment_setup_page.dart';
import '../pages/schedule_tomorrow_page.dart';
import '../pages/maintenance_requests_review_page.dart';
import '../pages/settings_page.dart';

class DrawerMenu extends StatelessWidget {
  final String username;
  final UserRole role;

  const DrawerMenu({Key? key, required this.username, required this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(role.name),
          ),
          // الرئيسية
          _buildTile(
            context,
            label: 'الرئيسية',
            icon: Icons.home,
            route: HomePage.route,
            visible: true,
          ),
          // تحميل فواتير المشاريع (admin)
          _buildTile(
            context,
            label: 'تحميل فواتير المشاريع',
            icon: Icons.receipt,
            route: ProjectInvoicePage.route,
            visible: role == UserRole.admin,
          ),
          // تحميل فواتير (maintenanceManager, technician, assistant)
          _buildTile(
            context,
            label: 'تحميل فواتير',
            icon: Icons.receipt,
            route: UploadInvoicePage.route,
            visible: role == UserRole.technician || role == UserRole.assistant,
          ),
          // تقارير العدة والأدوات (admin)
          _buildTile(
            context,
            label: 'تقارير العدة والأدوات',
            icon: Icons.report,
            route: ToolsReportsPage.route,
            visible: role == UserRole.admin,
          ),
          // إدارة المستخدمين (admin)
          _buildTile(
            context,
            label: 'إدارة المستخدمين',
            icon: Icons.people,
            route: UserManagementPage.route,
            visible: role == UserRole.admin,
          ),
          // مراجعة طلبات الأموال (admin)
          _buildTile(
            context,
            label: 'مراجعة طلبات الأموال',
            icon: Icons.money,
            route: MoneyRequestsReviewPage.route,
            visible: role == UserRole.admin,
          ),
          // توليد ملفات (admin)
          _buildTile(
            context,
            label: 'توليد ملفات',
            icon: Icons.file_download,
            route: ExportReportsPage.route,
            visible: role == UserRole.admin,
          ),
          // العدة والأدوات (admin, maintenanceManager)
          _buildTile(
            context,
            label: 'العدة والأدوات',
            icon: Icons.build,
            route: EquipmentSetupPage.route,
            visible: role == UserRole.admin,
          ),
          // تحديد موعد الدوام غداً (admin, maintenanceManager)
          _buildTile(
            context,
            label: 'تحديد موعد الدوام غداً',
            icon: Icons.calendar_today,
            route: ScheduleTomorrowPage.route,
            visible: role == UserRole.admin,
          ),
          // مراجعة طلبات الصيانة (admin)
          _buildTile(
            context,
            label: 'مراجعة طلبات الصيانة',
            icon: Icons.build_circle,
            route: MaintenanceRequestsReviewPage.route,
            visible: role == UserRole.admin,
          ),
          // الإعدادات (all)
          _buildTile(
            context,
            label: 'الإعدادات',
            icon: Icons.settings,
            route: SettingsPage.route,
            visible: true,
          ),
          const Divider(),
          // تسجيل الخروج (all)
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل الخروج'),
            onTap: () {
              Navigator.pushReplacementNamed(context, LoginPage.route);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String route,
    required bool visible,
  }) {
    if (!visible) return const SizedBox.shrink();
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
