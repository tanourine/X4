import 'dart:math';
import 'package:flutter/material.dart';

class ScheduleTomorrowPage extends StatefulWidget {
  static const routeName = '/schedule-tomorrow';
  const ScheduleTomorrowPage({super.key});

  @override
  State<ScheduleTomorrowPage> createState() => _ScheduleTomorrowPageState();
}

class _ScheduleTomorrowPageState extends State<ScheduleTomorrowPage> {
  final _techs = ['Ali', 'Mohammed', 'Kashif'];
  final _times = <String, TimeOfDay?>{};
  @override
  void initState() {
    super.initState();
    for (var t in _techs) _times[t] = null;
  }

  Future<void> _pickTime(String tech) async {
    final t = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (t != null) setState(() => _times[tech] = t);
  }

  String _randomMsg(String tm) {
    final msgs = [
      '❄️ غدًا تحدي جديد الساعة $tm! حضرّوا عدتكم.',
      '🌟 استعدّوا للانطلاق غدًا عند $tm بابتسامة!',
    ];
    return msgs[Random().nextInt(msgs.length)];
  }

  void _save() {
    for (var tech in _techs) {
      final t = _times[tech];
      final tm = t?.format(context) ?? 'غير محدد';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$tech → ${t != null ? _randomMsg(tm) : 'دوام غير محدد'}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Tomorrow')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _times.updateAll((_, __) => const TimeOfDay(hour: 8, minute: 0)),
                child: const Text('Set All 08:00'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _times.updateAll((_, __) => null),
                child: const Text('Clear All'),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: _techs.map((tech) {
                final t = _times[tech];
                return Card(
                  child: ListTile(
                    title: Text(tech),
                    subtitle: Text('Time: ${t?.format(context) ?? 'None'}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () => _pickTime(tech),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: _save, child: const Text('Save & Notify')),
          ),
        ]),
      ),
    );
  }
}
