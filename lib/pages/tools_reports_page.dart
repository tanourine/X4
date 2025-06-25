import 'package:flutter/material.dart';

class ToolsReportsPage extends StatelessWidget {
  static const route = '/tools-reports';
  const ToolsReportsPage({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('تقارير العدة والأدوات')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: const [
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'فني'))),
            SizedBox(width: 8),
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'أداة'))),
          ]),
          const SizedBox(height: 8),
          Row(children: const [
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'الحالة'))),
            SizedBox(width: 8),
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'من تاريخ'))),
            SizedBox(width: 8),
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'إلى تاريخ'))),
          ]),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {}, child: const Text('عرض')),
          const SizedBox(height: 12),
          // هنا DataTable أو ListView للنتائج
          const Expanded(
            child: Center(child: Text('نتائج التقارير تظهر هنا')),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(onPressed: () {}, child: const Text('Export Excel')),
            ElevatedButton(onPressed: () {}, child: const Text('Export PDF')),
          ]),
        ]),
      ),
    );
  }
}
