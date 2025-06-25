import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/upload_invoice_page.dart';
import 'pages/equipment_check_page.dart';
import 'pages/tools_reports_page.dart';
import 'pages/schedule_tomorrow_page.dart';
import 'pages/settings_page.dart';
import 'pages/reports_page.dart';

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
        '/':                (ctx) => const LoginPage(),
        '/home':            (ctx) => const HomePage(),
        '/upload-invoice':  (ctx) => const UploadInvoicePage(),
        '/equipment-check': (ctx) => const EquipmentCheckPage(),
        '/tools-reports':   (ctx) => const ToolsReportsPage(),
        '/schedule-tomorrow': (ctx) => const ScheduleTomorrowPage(),
        '/settings':        (ctx) => const SettingsPage(),
        '/reports':         (ctx) => const ReportsPage(),
      },
    );
  }
}
