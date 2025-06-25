import 'package:flutter/material.dart';

class ScheduleTomorrowPage extends StatefulWidget {
  static const route = '/schedule-tomorrow';
  const ScheduleTomorrowPage({super.key});
  @override
  State<ScheduleTomorrowPage> createState() => _ScheduleTomorrowPageState();
}

class _ScheduleTomorrowPageState extends State<ScheduleTomorrowPage> {
  final _techs = ['tech1', 'tech2'];
  final Map<String, TimeOfDay?> _times = {};
  final Map<String, TextEditingController> _notes = {};

  @override
  void initState() {
    super.initState();
    for (var t in _techs) {
      _times[t] = null;
      _notes[t] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var c in _notes.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickTime(String tech) async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 8, minute: 0),
    );
    if (t != null) setState(() => _times[tech] = t);
  }

  void _setAll() {
    setState(() {
      for (var t in _techs) {
        _times[t] = const TimeOfDay(hour: 8, minute: 0);
      }
    });
  }

  void _clearAll() {
    setState(() {
      for (var t in _techs) {
        _times[t] = null;
      }
    });
  }

  void _submit() {
    // هنا إرسال الإشعارات التحفيزية لكل فني
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم جدولة دوام الغد')),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحديد موعد الدوام غداً')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(onPressed: _setAll, child: const Text('Set All @08:00')),
            ElevatedButton(onPressed: _clearAll, child: const Text('Clear All')),
          ]),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: _techs.map((tech) {
                final t = _times[tech];
                return Card(
                  child: ListTile(
                    title: Text(tech),
                    subtitle: Text(t == null ? 'None' : t.format(ctx)),
                    trailing: IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () => _pickTime(tech),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(onPressed: _submit, child: const Text('Submit')),
        ]),
      ),
    );
  }
}
