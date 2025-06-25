import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/upload_invoice_page.dart';
import 'pages/project_invoice_page.dart';
import 'pages/equipment_setup_page.dart';
import 'pages/equipment_check_page.dart';
import 'pages/tools_reports_page.dart';
import 'pages/schedule_tomorrow_page.dart';
import 'pages/maintenance_requests_review_page.dart';
import 'pages/request_page.dart';
import 'pages/money_requests_review_page.dart';
import 'pages/user_management_page.dart';
import 'pages/export_reports_page.dart';
import 'pages/attendance_page.dart';
import 'pages/settings_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tanourine App',
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.route,
      routes: {
        LoginPage.route: (_) => const LoginPage(),
        HomePage.route: (_) => const HomePage(),
        UploadInvoicePage.route: (_) => const UploadInvoicePage(),
        ProjectInvoicePage.route: (_) => const ProjectInvoicePage(),
        EquipmentSetupPage.route: (_) => const EquipmentSetupPage(),
        EquipmentCheckPage.route: (_) => const EquipmentCheckPage(),
        ToolsReportsPage.route: (_) => const ToolsReportsPage(),
        ScheduleTomorrowPage.route: (_) => const ScheduleTomorrowPage(),
        MaintenanceRequestsReviewPage.route: (_) => const MaintenanceRequestsReviewPage(),
        RequestPage.route: (_) => const RequestPage(),
        MoneyRequestsReviewPage.route: (_) => const MoneyRequestsReviewPage(),
        UserManagementPage.route: (_) => const UserManagementPage(),
        ExportReportsPage.route: (_) => const ExportReportsPage(),
        AttendancePage.route: (_) => const AttendancePage(),
        SettingsPage.route: (_) => const SettingsPage(),
      },
    );
  }
}
