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
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        HomePage.routeName: (_) => const HomePage(),
        UploadInvoicePage.routeName: (_) => const UploadInvoicePage(),
        EquipmentCheckPage.routeName: (_) => const EquipmentCheckPage(),
        ToolsReportsPage.routeName: (_) => const ToolsReportsPage(),
        ScheduleTomorrowPage.routeName: (_) => const ScheduleTomorrowPage(),
        SettingsPage.routeName: (_) => const SettingsPage(),
        ReportsPage.routeName: (_) => const ReportsPage(),
      },
    );
  }
}
