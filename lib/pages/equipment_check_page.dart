import 'package:flutter/material.dart';

class EquipmentCheckPage extends StatefulWidget {
  static const routeName = '/equipment-check';
  const EquipmentCheckPage({super.key});
  @override
  State<EquipmentCheckPage> createState() => _EquipmentCheckPageState();
}

class _EquipmentCheckPageState extends State<EquipmentCheckPage> {
  // بيانات وهمية
  final _techs = ['Ali', 'Mohammed', 'Kashif'];
  final _toolsByTech = {
    'Ali': ['Wrench', 'Screwdriver'],
    'Mohammed': ['Thermometer'],
    'Kashif': ['Pressure Gauge'],
  };
  final _state = <String, Map<String, dynamic>>{};

  @override
  void initState() {
    super.initState();
    for (var t in _techs) {
      for (var tool in _toolsByTech[t]!) {
        _state['$t|$tool'] = {'checked': false, 'status': 'Pending', 'note': ''};
      }
    }
  }

  Future<void> _openDialog(String tech, String tool) async {
    final key = '$tech|$tool';
    String status = _state[key]!['status'];
    final noteCtrl = TextEditingController(text: _state[key]!['note']);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Check $tool for $tech'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          RadioListTile<String>(
            title: const Text('Good'),
            value: 'Good',
            groupValue: status,
            onChanged: (v) => setState(() => status = v!),
          ),
          RadioListTile<String>(
            title: const Text('Needs Maintenance'),
            value: 'Needs Maintenance',
            groupValue: status,
            onChanged: (v) => setState(() => status = v!),
          ),
          RadioListTile<String>(
            title: const Text('Missing'),
            value: 'Missing',
            groupValue: status,
            onChanged: (v) => setState(() => status = v!),
          ),
          TextField(
            controller: noteCtrl,
            decoration: const InputDecoration(labelText: 'Note'),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _state[key]!['checked'] = true;
                _state[key]!['status'] = status;
                _state[key]!['note'] = noteCtrl.text.trim();
              });
              Navigator.pop(ctx);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Equipment Check')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _techs.map((tech) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('👨‍🔧 $tech', style: const TextStyle(fontWeight: FontWeight.bold)),
              ..._toolsByTech[tech]!.map((tool) {
                final st = _state['$tech|$tool']!;
                return Card(
                  child: ListTile(
                    title: Text(tool),
                    subtitle: Text(st['checked']
                        ? st['status']
                        : 'Not checked yet'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openDialog(tech, tool),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}
