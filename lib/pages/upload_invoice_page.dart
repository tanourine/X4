import 'package:flutter/material.dart';

class UploadInvoicePage extends StatefulWidget {
  static const routeName = '/upload-invoice';
  const UploadInvoicePage({super.key});
  @override
  State<UploadInvoicePage> createState() => _UploadInvoicePageState();
}

class _UploadInvoicePageState extends State<UploadInvoicePage> {
  final _types = [
    'Maintenance Expense (نفقات الصيانة)',
    'Fuel (بترول)',
    'Other (أخرى)'
  ];
  String? _selectedType;
  final _notesCtrl = TextEditingController();
  bool _hasImage = false, _submitting = false;
  final _today = DateTime.now().toLocal().toString().split(' ')[0];
  final List<Map<String, String>> _uploaded = [];

  Future<void> _attachImage() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Camera'),
          ),
          ListTile(
            leading: Icon(Icons.photo),
            title: Text('Gallery'),
          ),
        ],
      ),
    );
    if (choice != null) setState(() => _hasImage = true);
  }

  Future<void> _submit() async {
    if (_selectedType == null || !_hasImage || _notesCtrl.text.isEmpty) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _uploaded.insert(0, {
        'type': _selectedType!,
        'date': _today,
        'notes': _notesCtrl.text.trim(),
      });
      _submitting = false;
      _selectedType = null;
      _notesCtrl.clear();
      _hasImage = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invoice uploaded successfully')),
    );
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Invoice')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Invoice Type'),
              value: _selectedType,
              items: _types
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedType = v),
            ),
            const SizedBox(height: 12),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Date', hintText: _today, border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.attach_file),
              label: Text(_hasImage ? 'Image Attached' : 'Attach Image'),
              onPressed: _attachImage,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit'),
              ),
            ),
            const SizedBox(height: 24),
            if (_uploaded.isNotEmpty) ...[
              const Text('Today\'s Uploads:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._uploaded.map((rec) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.insert_drive_file),
                      title: Text(rec['type']!),
                      subtitle: Text('${rec['date']} – ${rec['notes']}'),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
