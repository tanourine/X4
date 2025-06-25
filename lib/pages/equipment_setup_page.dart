import 'package:flutter/material.dart';

class EquipmentSetupPage extends StatefulWidget {
  static const route = '/equipment-setup';
  const EquipmentSetupPage({super.key});
  @override
  State<EquipmentSetupPage> createState() => _EquipmentSetupPageState();
}

class _EquipmentSetupPageState extends State<EquipmentSetupPage> {
  final _toolNameCtrl = TextEditingController();
  final _technicians = ['tech1', 'tech2'];
  String? _selectedTech;
  bool _hasImage = false;
  final List<Map<String, String>> _tools = [];

  Future<void> _pickImage() async {
    // مجرد محاكاة للالتقاط
    setState(() => _hasImage = true);
  }

  void _addTool() {
    if (_toolNameCtrl.text.trim().isEmpty || _selectedTech == null || !_hasImage) return;
    setState(() {
      _tools.add({
        'name': _toolNameCtrl.text.trim(),
        'tech': _selectedTech!,
      });
      _toolNameCtrl.clear();
      _selectedTech = null;
      _hasImage = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إضافة الأداة')),
    );
  }

  @override
  void dispose() {
    _toolNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('العدة والأدوات')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: _toolNameCtrl,
            decoration: const InputDecoration(
              labelText: 'اسم الأداة *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'الفني المسؤول'),
            value: _selectedTech,
            items: _technicians
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _selectedTech = v),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: Text(_hasImage ? 'تم اختيار صورة' : 'اختر صورة'),
            onPressed: _pickImage,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _addTool,
            child: const Text('إضافة'),
          ),
          const Divider(height: 32),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('الأدوات المضافة:', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tools.length,
              itemBuilder: (_, i) {
                final tool = _tools[i];
                return ListTile(
                  title: Text(tool['name']!),
                  subtitle: Text('مسؤول: ${tool['tech']}'),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
