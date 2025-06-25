import 'package:flutter/material.dart';

/// صفحة "تحميل الفاتورة" متكاملة للاستخدام داخل مشروع Flutter
/// احفظ الملف في `lib/pages/upload_invoice_page.dart` وسجّل المسار في `main.dart`.

class UploadInvoicePage extends StatefulWidget {
  static const routeName = '/upload-invoice';

  const UploadInvoicePage({Key? key}) : super(key: key);

  @override
  _UploadInvoicePageState createState() => _UploadInvoicePageState();
}

class _UploadInvoicePageState extends State<UploadInvoicePage> {
  final List<String> _types = ['Maintenance', 'Fuel', 'Other'];
  String? _selectedType;
  final TextEditingController _notesCtrl = TextEditingController();
  bool _hasImage = false;
  bool _submitting = false;

  final String _today =
      DateTime.now().toLocal().toIso8601String().split('T').first;
  final List<Map<String, String>> _uploads = [];

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _attachImage() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (c) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('كاميرا'),
            onTap: () => Navigator.pop(c, 'camera'),
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('معرض'),
            onTap: () => Navigator.pop(c, 'gallery'),
          ),
        ],
      ),
    );
    if (choice != null) {
      setState(() => _hasImage = true);
    }
  }

  Future<void> _submit() async {
    if (_selectedType == null || !_hasImage || _notesCtrl.text.trim().isEmpty) {
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(seconds: 1)); // محاكاة معالجة

    // أضف السجل إلى القائمة
    setState(() {
      _uploads.insert(0, {
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
      const SnackBar(content: Text('تم رفع الفاتورة بنجاح')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحميل الفاتورة')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'نوع الفاتورة'),
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
                labelText: 'التاريخ',
                border: const OutlineInputBorder(),
                hintText: _today,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.attach_file),
              label: Text(_hasImage ? '✅ تم إرفاق الصورة' : 'إرفاق صورة'),
              onPressed: _attachImage,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'ملاحظة *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('إرسال'),
              ),
            ),
            const SizedBox(height: 24),
            if (_uploads.isNotEmpty) ...[
              const Text(
                'التحميلات اليوم:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._uploads.map((u) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.insert_drive_file),
                      title: Text(u['type']!),
                      subtitle: Text('${u['date']} — ${u['notes']}'),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

// ------------------------ main.dart ------------------------

void main() {
  runApp(const InvoiceApp());
}

class InvoiceApp extends StatelessWidget {
  const InvoiceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رفع الفواتير',
      debugShowCheckedModeBanner: false,
      initialRoute: UploadInvoicePage.routeName,
      routes: {
        UploadInvoicePage.routeName: (_) => const UploadInvoicePage(),
      },
    );
  }
}
