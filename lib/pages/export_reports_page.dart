import 'package:flutter/material.dart';

class ExportReportsPage extends StatelessWidget {
  static const route = '/export-reports';
  const ExportReportsPage({super.key});
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('توليد ملفات')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: const [
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'فني'))),
            SizedBox(width: 8),
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'مشروع'))),
            SizedBox(width: 8),
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'شهر'))),
          ]),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {}, child: const Text('Preview')),
          const SizedBox(height: 12),
          const Expanded(child: Center(child: Text('Preview Table'))),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(onPressed: () {}, child: const Text('Export Excel')),
            ElevatedButton(onPressed: () {}, child: const Text('Export PDF')),
          ]),
        ]),
      ),
    );
  }
}
