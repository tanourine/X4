import 'package:flutter/material.dart';

/// Ready-to-use ReportsPage for a real Flutter project.
/// Place this file under `lib/pages/reports_page.dart` and register its route in main.dart.

enum UserRole { admin, manager, technician, assistant }

/// نموذج بيانات لحضور الموظف
class AttendanceRecord {
  final String employee;
  final DateTime date;
  final String project;
  final List<Period> periods;

  AttendanceRecord({
    required this.employee,
    required this.date,
    required this.project,
    required this.periods,
  });
}

/// نموذج لفترة عمل واحدة
class Period {
  final TimeOfDay inTime;
  final TimeOfDay outTime;
  final String note;

  Period(this.inTime, this.outTime, this.note);
}

class ReportsPage extends StatefulWidget {
  static const String routeName = '/reports';

  final UserRole role;

  const ReportsPage({Key? key, required this.role}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final List<String> _employees = ['All (الكل)', 'Ali (علي)', 'Mohammed (محمد)'];
  final List<String> _projects = ['All (الكل)', 'Maintenance (صيانة)', 'Project A'];
  final List<String> _months = [
    '0 - All Months (كل الأشهر)',
    '1 - Jan (يناير)',
    '2 - Feb (فبراير)',
    '3 - Mar (مارس)',
    '4 - Apr (أبريل)',
    '5 - May (مايو)',
    '6 - Jun (يونيو)',
    '7 - Jul (يوليو)',
    '8 - Aug (أغسطس)',
    '9 - Sep (سبتمبر)',
    '10 - Oct (أكتوبر)',
    '11 - Nov (نوفمبر)',
    '12 - Dec (ديسمبر)',
  ];

  String _selectedEmployee = 'All (الكل)';
  String _selectedProject = 'All (الكل)';
  int _selectedMonth = 0;
  String _format = 'Excel (XLSX)';

  bool _loading = false;
  late List<AttendanceRecord> _allData;
  List<AttendanceRecord> _preview = [];

  @override
  void initState() {
    super.initState();
    _allData = List.generate(20, (i) {
      final date = DateTime(2025, (i % 12) + 1, (i % 28) + 1);
      return AttendanceRecord(
        employee: i % 2 == 0 ? 'Ali (علي)' : 'Mohammed (محمد)',
        date: date,
        project: i % 3 == 0 ? 'Maintenance (صيانة)' : 'Project A',
        periods: [
          Period(const TimeOfDay(hour: 8, minute: 0), const TimeOfDay(hour: 12, minute: 0), 'Note1'),
          Period(const TimeOfDay(hour: 13, minute: 0), const TimeOfDay(hour: 17, minute: 0), 'Note2'),
          Period(const TimeOfDay(hour: 17, minute: 30), const TimeOfDay(hour: 19, minute: 0), 'Note3'),
        ],
      );
    });
  }

  void _generatePreview() {
    setState(() {
      _preview = _allData.where((rec) {
        if (_selectedEmployee != 'All (الكل)' && rec.employee != _selectedEmployee) return false;
        if (_selectedProject != 'All (الكل)' && rec.project != _selectedProject) return false;
        if (_selectedMonth != 0 && rec.date.month != _selectedMonth) return false;
        return true;
      }).toList();
    });
  }

  Future<void> _export() async {
    setState(() {
      _loading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _loading = false;
    });

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
    if (widget.role != UserRole.admin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reports (توليد ملفات)')),
        body: const Center(child: Text('Access Denied (غير مصرح)')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reports (توليد ملفات)')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Filters Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(labelText: 'Employee (الموظف)'),
                              value: _selectedEmployee,
                              items: _employees
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (v) => setState(() => _selectedEmployee = v!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              decoration: const InputDecoration(labelText: 'Month (الشهر)'),
                              value: _selectedMonth,
                              items: List.generate(
                                _months.length,
                                (i) => DropdownMenuItem(value: i, child: Text(_months[i])),
                              ),
                              onChanged: (v) => setState(() => _selectedMonth = v!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(labelText: 'Project (المشروع)'),
                              value: _selectedProject,
                              items: _projects
                                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                                  .toList(),
                              onChanged: (v) => setState(() => _selectedProject = v!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(labelText: 'Format (الصيغة)'),
                              value: _format,
                              items: ['Excel (XLSX)', 'PDF']
                                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                                  .toList(),
                              onChanged: (v) => setState(() => _format = v!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _generatePreview,
                            child: const Text('Generate Preview (عرض المعاينة)'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _preview.isEmpty || _loading ? null : _export,
                            child: _loading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Export (تصدير)'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Preview Table
              Expanded(
                child: _preview.isEmpty
                    ? const Center(child: Text('No data (لا توجد بيانات)'))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Employee')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Project')),
                            DataColumn(label: Text('Period1 In/Out | Note')),
                            DataColumn(label: Text('Period2 In/Out | Note')),
                            DataColumn(label: Text('Period3 In/Out | Note')),
                          ],
                          rows: _preview.map((rec) {
                            return DataRow(cells: [
                              DataCell(Text(rec.employee)),
                              DataCell(Text(rec.date.toIso8601String().split('T').first)),
                              DataCell(Text(rec.project)),
                              DataCell(Text(
                                  '${rec.periods[0].inTime.format(context)}/${rec.periods[0].outTime.format(context)}\n${rec.periods[0].note}')),
                              DataCell(Text(
                                  '${rec.periods[1].inTime.format(context)}/${rec.periods[1].outTime.format(context)}\n${rec.periods[1].note}')),
                              DataCell(Text(
                                  '${rec.periods[2].inTime.format(context)}/${rec.periods[2].outTime.format(context)}\n${rec.periods[2].note}')),
                            ]);
                          }).toList(),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
