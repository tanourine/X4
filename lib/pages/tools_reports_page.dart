import 'package:flutter/material.dart';

/// صفحة "تقارير العدة والأدوات" متكاملة للاستخدام داخل مشروع Flutter حقيقي
/// ضع هذا الملف تحت `lib/pages/tools_reports_page.dart` وسجّل مساره في `main.dart`.

enum UserRole { admin, manager, technician, assistant }

/// نموذج لنتيجة فحص الأداة
class ToolCheckRecord {
  final String technician;
  final String toolName;
  final DateTime dateChecked;
  final String status;
  final String notes;

  ToolCheckRecord({
    required this.technician,
    required this.toolName,
    required this.dateChecked,
    required this.status,
    required this.notes,
  });
}

class ToolsReportsPage extends StatefulWidget {
  static const String routeName = '/tools_reports';
  final UserRole role;
  const ToolsReportsPage({Key? key, required this.role}) : super(key: key);

  @override
  _ToolsReportsPageState createState() => _ToolsReportsPageState();
}

class _ToolsReportsPageState extends State<ToolsReportsPage> {
  // بيانات وهمية
  final List<String> _technicians = [
    'All (الكل)',
    'Mohammed (محمد)',
    'Ali (علي)',
    'Kashif (كاشف)',
  ];
  final List<String> _tools = [
    'All (الكل)',
    'Wrench (مفتاح إنجليزي)',
    'Screwdriver (مفك كهرباء)',
    'Thermometer (ميزان حرارة)',
    'Pressure Gauge (جهاز ضغط)',
  ];
  final List<String> _statuses = [
    'All (الكل)',
    'Good (سليمة)',
    'Needs Maintenance (تحتاج صيانة)',
    'Missing (مفقودة)',
  ];
  final List<String> _formats = [
    'Excel (XLSX)',
    'PDF',
  ];

  String _selectedTech = 'All (الكل)';
  String _selectedTool = 'All (الكل)';
  String _selectedStatus = 'All (الكل)';
  String _selectedFormat = 'Excel (XLSX)';
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();

  bool _loading = false;
  late List<ToolCheckRecord> _allRecords;
  List<ToolCheckRecord> _preview = [];

  @override
  void initState() {
    super.initState();
    // توليد بيانات تجريبية
    _allRecords = List.generate(30, (i) {
      final date = DateTime.now().subtract(Duration(days: i));
      return ToolCheckRecord(
        technician: _technicians[(i % (_technicians.length - 1)) + 1],
        toolName: _tools[(i % (_tools.length - 1)) + 1],
        dateChecked: date,
        status: _statuses[(i % (_statuses.length - 1)) + 1],
        notes: 'Note ${i + 1}',
      );
    });
  }

  Future<void> _pickFromDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _fromDate = d);
  }

  Future<void> _pickToDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _toDate,
      firstDate: _fromDate,
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _toDate = d);
  }

  void _generatePreview() {
    setState(() {
      _preview = _allRecords.where((r) {
        if (_selectedTech != 'All (الكل)' && r.technician != _selectedTech) return false;
        if (_selectedTool != 'All (الكل)' && r.toolName != _selectedTool) return false;
        if (_selectedStatus != 'All (الكل)' && r.status != _selectedStatus) return false;
        if (r.dateChecked.isBefore(_fromDate) || r.dateChecked.isAfter(_toDate)) return false;
        return true;
      }).toList();
    });
  }

  Future<void> _export() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report exported successfully (تم تصدير الملف بنجاح)')),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Export Complete'),
        content: const Text('Choose an action (اختر إجراءً)'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Open (فتح)')),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Share (مشاركة)')),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close (إغلاق)')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // صلاحية الوصول: admin فقط
    if (widget.role != UserRole.admin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tools & Equipment Reports')),
        body: const Center(child: Text('Access Denied (غير مصرح)')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Tools & Equipment Reports (تقارير العدة والأدوات)')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // فلاتر
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Technician (الفني)'),
                value: _selectedTech,
                items: _technicians.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _selectedTech = v!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tool Name (اسم الأداة)'),
                value: _selectedTool,
                items: _tools.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _selectedTool = v!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Status (الحالة)'),
                value: _selectedStatus,
                items: _statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _selectedStatus = v!),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickFromDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'From (من)'),
                  child: Text(_fromDate.toLocal().toString().split(' ')[0]),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickToDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'To (إلى)'),
                  child: Text(_toDate.toLocal().toString().split(' ')[0]),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Format (الصيغة)'),
              ..._formats.map((fmt) => RadioListTile<String>(
                    title: Text(fmt),
                    value: fmt,
                    groupValue: _selectedFormat,
                    onChanged: (v) => setState(() => _selectedFormat = v!),
              )),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _generatePreview,
                child: const Text('Generate Preview (عرض المعاينة)'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _preview.isEmpty || _loading ? null : _export,
                child: _loading
                    ? const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2,color:Colors.white))
                    : const Text('Export (تصدير)'),
              ),
              const SizedBox(height: 16),
              // معاينة البيانات
              if (_preview.isEmpty)
                const Center(child: Text('No data (لا توجد بيانات)'))
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Technician')),
                      DataColumn(label: Text('Tool')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Notes')),
                    ],
                    rows: _preview.map((r) => DataRow(cells: [
                      DataCell(Text(r.technician)),
                      DataCell(Text(r.toolName)),
                      DataCell(Text(r.dateChecked.toLocal().toString().split(' ')[0])),
                      DataCell(Text(r.status)),
                      DataCell(Text(r.notes)),
                    ])).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------ main.dart ------------------------

void main() {
  runApp(const ToolsReportsApp());
}

class ToolsReportsApp extends StatelessWidget {
  const ToolsReportsApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tools & Equipment Reports',
      debugShowCheckedModeBanner: false,
      initialRoute: ToolsReportsPage.routeName,
      routes: {
        ToolsReportsPage.routeName: (_) => const ToolsReportsPage(role: UserRole.admin),
      },
    );
  }
}
