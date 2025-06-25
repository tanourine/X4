import 'package:flutter/material.dart';

class EquipmentCheckPage extends StatefulWidget {
  static const route = '/equipment-check';
  const EquipmentCheckPage({super.key});
  @override
  State<EquipmentCheckPage> createState() => _EquipmentCheckPageState();
}

class _EquipmentCheckPageState extends State<EquipmentCheckPage> {
  final _toolsByTech = {
    'tech1': ['Wrench', 'Screwdriver'],
    'tech2': ['Multimeter'],
  };
  final Map<String, String> _status = {}; // key: 'tech-tool', value: status

  void _editStatus(String tech, String tool) async {
    final key = '$tech#$tool';
    String current = _status[key] ?? 'Not checked';
    final choice = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('حالة $tool لدى $tech'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          RadioListTile(
            title: const Text('✅ Good'),
            value: 'Good',
            groupValue: current,
            onChanged: (v) => Navigator.pop(c, v),
          ),
          RadioListTile(
            title: const Text('⚠️ Needs Maintenance'),
            value: 'Needs Maintenance',
            groupValue: current,
            onChanged: (v) => Navigator.pop(c, v),
          ),
          RadioListTile(
            title: const Text('❌ Missing'),
            value: 'Missing',
            groupValue: current,
            onChanged: (v) => Navigator.pop(c, v),
          ),
        ]),
      ),
    );
    if (choice != null) {
      setState(() => _status[key] = choice);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تحديث الحالة: $choice')),
      );
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('تشييك العدة')),
      body: ListView(
        children: _toolsByTech.entries.map((e) {
          return ExpansionTile(
            title: Text('👨‍🔧 ${e.key}'),
            children: e.value.map((tool) {
              final key = '${e.key}#$tool';
              final stat = _status[key] ?? 'Not checked';
              return ListTile(
                title: Text(tool),
                subtitle: Text(stat),
                onTap: () => _editStatus(e.key, tool),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
