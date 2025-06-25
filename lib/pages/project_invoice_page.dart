import 'package:flutter/material.dart';

/// نموذج بيانات الإشعار
class NotificationItem {
  final String title;
  final String body;
  final DateTime timestamp;

  NotificationItem({
    required this.title,
    required this.body,
    required this.timestamp,
  });
}

/// ValueNotifier لإدارة قائمة الإشعارات داخل التطبيق
final ValueNotifier<List<NotificationItem>> notificationsNotifier =
    ValueNotifier<List<NotificationItem>>([]);

/// دالة لإضافة إشعار جديد
void addNotification(NotificationItem item) {
  final list = List<NotificationItem>.from(notificationsNotifier.value);
  list.add(item);
  notificationsNotifier.value = list;
}

/// صفحة "تحميل فاتورة مشروع" الجاهزة للاستخدام
/// ضع هذا الملف تحت `lib/pages/project_invoices_page.dart` وسجّل مساره في `main.dart`.
class ProjectInvoicesPage extends StatefulWidget {
  static const String routeName = '/project_invoices';
  /// اسم المستخدم الذي قام بالرفع
  final String userName;

  const ProjectInvoicesPage({Key? key, required this.userName}) : super(key: key);

  @override
  _ProjectInvoicesPageState createState() => _ProjectInvoicesPageState();
}

class _ProjectInvoicesPageState extends State<ProjectInvoicesPage> {
  // قائمة المشاريع (يتم ملؤها لاحقاً من مصدر بيانات)
  final List<String> _projects = ['Project A', 'Project B', 'Project C'];

  String? _selectedProject;
  final TextEditingController _notesCtrl = TextEditingController();
  String? _selectedImagePath;
  late final String _currentDate;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  /// محاكاة اختيار صورة من الكاميرا أو المعرض
  Future<void> _attachPhoto() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera (الكاميرا)'),
            onTap: () => Navigator.pop(_, 'camera'),
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery (المعرض)'),
            onTap: () => Navigator.pop(_, 'gallery'),
          ),
        ],
      ),
    );
    if (choice != null) {
      setState(() {
        _selectedImagePath = choice == 'camera'
            ? 'Image from Camera'
            : 'Image from Gallery';
      });
    }
  }

  bool get _isFormValid {
    return _selectedProject != null &&
        _notesCtrl.text.trim().isNotEmpty &&
        _selectedImagePath != null;
  }

  /// عملية الرفع (محاكاة)
  Future<void> _upload() async {
    if (!_isFormValid) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));

    // إضافة إشعار داخل التطبيق
    addNotification(NotificationItem(
      title: 'New Project Invoice',
      body:
          'Invoice for ${_selectedProject!} uploaded by ${widget.userName} on $_currentDate',
      timestamp: DateTime.now(),
    ));

    setState(() {
      _loading = false;
      _selectedProject = null;
      _notesCtrl.clear();
      _selectedImagePath = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invoice uploaded successfully (تم التحميل)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Project Invoice (تحميل فاتورة مشروع)'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Dropdown للمشروع
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Project (المشروع)',
                  border: OutlineInputBorder(),
                ),
                value: _selectedProject,
                items: _projects
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedProject = v),
              ),
              const SizedBox(height: 16),
              // التاريخ (قراءة فقط)
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date (التاريخ)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.date_range),
                  hintText: _currentDate,
                ),
              ),
              const SizedBox(height: 16),
              // الملاحظات
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
              // إرفاق صورة
              ElevatedButton.icon(
                onPressed: _attachPhoto,
                icon: const Icon(Icons.attach_file),
                label: Text(_selectedImagePath == null
                    ? 'Attach Photo (إرفاق صورة)'
                    : '✅ Photo Attached'),
              ),
              const Spacer(),
              // زر الرفع
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isFormValid && !_loading ? _upload : null,
                  child: _loading
                      ? const CircularProgressIndicator(
                          color: Colors.white)
                      : const Text('Upload (تحميل)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
