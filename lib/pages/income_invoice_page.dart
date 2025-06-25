import 'package:flutter/material.dart';

/// Ready-to-use Upload Invoice page.
/// Place this file under `lib/pages/upload_invoice_page.dart` and register its route in main.dart.

enum UserRole { admin, maintenanceManager, technician, assistant }

/// Represents a single invoice record
class InvoiceRecord {
  final String type;
  final String date;
  final String notes;
  InvoiceRecord(this.type, this.date, this.notes);
}

class UploadInvoicePage extends StatefulWidget {
  static const String routeName = '/upload_invoice';
  final UserRole role;

  const UploadInvoicePage({Key? key, required this.role}) : super(key: key);

  @override
  _UploadInvoicePageState createState() => _UploadInvoicePageState();
}

class _UploadInvoicePageState extends State<UploadInvoicePage> {
  final List<String> _types = [
    'Maintenance Expense (نفقات الصيانة)',
    'Fuel (بترول)',
    'Other (أخرى)',
  ];
  String? _selectedType;

  late final String _today;
  bool _hasImage = false;
  final TextEditingController _notesCtrl = TextEditingController();
  bool _submitting = false;
  final List<InvoiceRecord> _uploaded = [];

  @override
  void initState() {
    super.initState();
    _today = DateTime.now().toLocal().toString().split(' ')[0];
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _attachImage() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera (كاميرا)'),
            onTap: () => Navigator.pop(ctx, 'camera'),
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery (معرض)'),
            onTap: () => Navigator.pop(ctx, 'gallery'),
          ),
        ],
      ),
    );
    if (choice != null) {
      setState(() => _hasImage = true);
    }
  }

  bool get _isValid =>
      _selectedType != null && _hasImage && _notesCtrl.text.trim().isNotEmpty;

  Future<void> _submit() async {
    if (!_isValid) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _uploaded.insert(0, InvoiceRecord(_selectedType!, _today, _notesCtrl.text.trim()));
      _submitting = false;
      _selectedType = null;
      _notesCtrl.clear();
      _hasImage = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invoice uploaded successfully (تم رفع الفاتورة بنجاح)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canAccess = widget.role == UserRole.maintenanceManager || widget.role == UserRole.technician;
    if (!canAccess) {
      return Scaffold(
        appBar: AppBar(title: const Text('Upload Invoice (تحميل الفاتورة)')),
        body: const Center(child: Text('Access Denied (غير مصرح)')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Invoice (تحميل الفاتورة)')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Invoice Type (نوع الفاتورة)',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedType,
                  items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (v) => setState(() => _selectedType = v),
                ),
                const SizedBox(height: 12),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date (التاريخ)',
                    border: const OutlineInputBorder(),
                    hintText: _today,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.attach_file),
                  label: Text(_hasImage ? '✅ Image Attached' : 'Attach Image (إرفاق صورة)'),
                  onPressed: _attachImage,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Notes * (ملاحظة)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isValid && !_submitting ? _submit : null,
                    child: _submitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Submit (إرسال)'),
                  ),
                ),
                const SizedBox(height: 24),
                if (_uploaded.isNotEmpty) ...[
                  const Text('Today\'s Uploads (التحميلات اليوم):', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._uploaded.map((rec) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: Text(rec.type),
                          subtitle: Text('${rec.date} — ${rec.notes}'),
                        ),
                      )),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
