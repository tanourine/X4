import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  static const routeName = '/reports';
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // لاحقًا نقرأ checkResults أو بيانات الحضور لبناء DataTable
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: const Center(child: Text('Reports Generation Page')),
    );
  }
}
