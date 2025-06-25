// lib/main.dart

import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/upload_invoice_page.dart';
import 'pages/project_invoice_page.dart';
// باقي الصفحات ستُضاف لاحقًا عندما تكون جاهزة

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tanourine App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/':               (ctx) => const LoginPage(),
        '/home':           (ctx) => const HomePage(),
        '/upload-invoice': (ctx) => const UploadInvoicePage(),
        '/project-invoice':(ctx) => const ProjectInvoicePage(),
        // عندما تصبح باقي الصفحات جاهزة، أضف هنا:
        // '/equipment-setup':       (_) => const EquipmentSetupPage(),
        // '/equipment-check':       (_) => const EquipmentCheckPage(),
        // '/tools-reports':         (_) => const ToolsReportsPage(),
        // '/schedule-tomorrow':     (_) => const ScheduleTomorrowPage(),
        // '/maintenance-requests':  (_) => const MaintenanceRequestsReviewPage(),
        // '/requests':              (_) => const RequestPage(),
        // '/money-requests-review': (_) => const MoneyRequestsReviewPage(),
        // '/user-management':       (_) => const UserManagementPage(),
        // '/export-reports':        (_) => const ExportReportsPage(),
        // '/attendance':            (_) => const AttendancePage(),
        // '/settings':              (_) => const SettingsPage(),
      },
    );
  }
}
