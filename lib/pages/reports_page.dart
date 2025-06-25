import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  static const route = '/request';
  const RequestPage({super.key});
  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _types = ['Cash In Hand', 'Bank Transfer'];
  String? _selectedType;
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  void _submit() {
    if (_selectedType == null ||
        _amountCtrl.text.trim().isEmpty ||
        _notesCtrl.text.trim().isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تقديم طلب ($_selectedType)')),
    );
    setState(() {
      _selectedType = null;
      _amountCtrl.clear();
      _notesCtrl.clear();
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلب')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'نوع الطلب'),
            value: _selectedType,
            items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => setState(() => _selectedType = v),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'المبلغ *'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesCtrl,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'ملاحظة *'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _submit, child: const Text('إرسال')),
        ]),
      ),
    );
  }
}
