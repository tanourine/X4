import 'package:flutter/material.dart';

class ProjectInvoicePage extends StatefulWidget {
  static const route = '/project-invoice';
  const ProjectInvoicePage({super.key});
  @override
  State<ProjectInvoicePage> createState() => _ProjectInvoicePageState();
}

class _ProjectInvoicePageState extends State<ProjectInvoicePage> {
  final _projects = ['Project A', 'Project B'];
  String? _sel;
  final _notesCtrl = TextEditingController();
  bool _hasImage = false, _submitting = false;
  final _today = DateTime.now().toLocal().toString().split(' ')[0];
  final _uploads = <Map<String, String>>[];

  Future<void> _attachImage() async {
    final c = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(leading: const Icon(Icons.camera_alt), title: const Text('كاميرا'), onTap: () => Navigator.pop(ctx, 'cam')),
        ListTile(leading: const Icon(Icons.photo),       title: const Text('معرض'), onTap: () => Navigator.pop(ctx, 'gal')),
      ]),
    );
    if (c != null) setState(() => _hasImage = true);
  }

  Future<void> _submit() async {
    if (_sel == null || !_hasImage || _notesCtrl.text.trim().isEmpty) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(seconds: 1));
    // إرسال إلى project_invoices_channel
    setState(() {
      _uploads.insert(0, {'project': _sel!, 'date': _today, 'notes': _notesCtrl.text.trim()});
      _submitting = false;
      _sel = null;
      _notesCtrl.clear();
      _hasImage = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم رفع فاتورة المشروع')));
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحميل فواتير المشاريع')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'المشروع'),
            value: _sel,
            items: _projects.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
            onChanged: (v) => setState(() => _sel = v),
          ),
          const SizedBox(height: 12),
          TextField(
            readOnly: true,
            decoration: InputDecoration(labelText: 'التاريخ', hintText: _today, border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.attach_file),
            label: Text(_hasImage ? 'تم إرفاق' : 'إرفاق صورة'),
            onPressed: _attachImage,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesCtrl,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'ملاحظة *', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: !_submitting ? _submit : null,
            child: _submitting ? const CircularProgressIndicator(color: Colors.white) : const Text('إرسال'),
          ),
          const SizedBox(height: 24),
          if (_uploads.isNotEmpty) ...[
            const Text('التحميلات اليوم:', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._uploads.map((u) => Card(
                  child: ListTile(
                    title: Text(u['project']!),
                    subtitle: Text('${u['date']} – ${u['notes']}'),
                  ),
                )),
          ],
        ]),
      ),
    );
  }
}
