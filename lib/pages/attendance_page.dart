import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  static const route = '/attendance';
  const AttendancePage({super.key});
  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _periods = <Map<String, dynamic>>[];
  final _projects = ['Maintenance', 'Project A'];
  bool _submitted = false;

  void _addPeriod() {
    if (_periods.length >= 3 || _submitted) return;
    setState(() {
      _periods.add({
        'start': TimeOfDay(hour: 9, minute: 0),
        'end': TimeOfDay(hour: 17, minute: 0),
        'project': _projects.first,
        'notes': '',
      });
    });
  }

  Future<void> _pickTime(int idx, bool isStart) async {
    final t = await showTimePicker(
      context: context,
      initialTime: _periods[idx][isStart ? 'start' : 'end'] as TimeOfDay,
    );
    if (t != null) {
      setState(() => _periods[idx][isStart ? 'start' : 'end'] = t);
    }
  }

  void _submit() {
    setState(() => _submitted = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تسجيل الدوام')),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    final today = DateTime.now().toLocal().toString().split(' ')[0];
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدوام')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Text('تاريخ: $today'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _submitted ? null : _addPeriod,
            child: const Text('إضافة فترة'),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _periods.length,
              itemBuilder: (_, i) {
                final p = _periods[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(children: [
                      Row(children: [
                        TextButton(
                          onPressed: _submitted ? null : () => _pickTime(i, true),
                          child: Text((p['start'] as TimeOfDay).format(ctx)),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: _submitted ? null : () => _pickTime(i, false),
                          child: Text((p['end'] as TimeOfDay).format(ctx)),
                        ),
                      ]),
                      DropdownButton<String>(
                        value: p['project'] as String,
                        items: _projects
                            .map((pr) => DropdownMenuItem(value: pr, child: Text(pr)))
                            .toList(),
                        onChanged: _submitted
                            ? null
                            : (v) => setState(() => p['project'] = v),
                      ),
                      TextField(
                        enabled: !_submitted,
                        decoration: const InputDecoration(labelText: 'ملاحظة *'),
                        onChanged: (v) => p['notes'] = v,
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _submitted || _periods.isEmpty ? null : _submit,
            child: const Text('إرسال'),
          ),
        ]),
      ),
    );
  }
}
