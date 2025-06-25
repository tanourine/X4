import 'dart:math';
import 'package:flutter/material.dart';

/// صفحة "تحديد موعد الدوام غدًا" الجاهزة للاستخدام
/// ضع هذا الملف تحت `lib/pages/schedule_tomorrow_page.dart` وسجّل مساره في `main.dart`.

enum UserRole { admin, supervisor, technician, assistant }

class ScheduleTomorrowPage extends StatefulWidget {
  static const String routeName = '/schedule_tomorrow';

  /// دور المستخدم الحالي للتحكم بالصلاحيات
  final UserRole role;

  const ScheduleTomorrowPage({Key? key, required this.role}) : super(key: key);

  @override
  _ScheduleTomorrowPageState createState() => _ScheduleTomorrowPageState();
}

class _ScheduleTomorrowPageState extends State<ScheduleTomorrowPage> {
  // قائمة الفنيين
  final List<String> _techs = ['Ali (علي)', 'Mohammed (محمد)', 'Kashif (كاشف)'];
  // مواعيد وملاحظات
  final Map<String, TimeOfDay?> _times = {};
  final Map<String, String> _notes = {};
  // رسائل تحفيزية
  final List<String> _messages = [
    '❄️ غدًا تحدي جديد في الصيانة الساعة {time}! حضرّوا عدتكم.',
    '🌟 استعدّوا للانطلاق غدًا عند {time} بابتسامة ونشاط!',
    '🛠️ دوام الغد يبدأ في {time}. لنحقق إنجازات جديدة!',
  ];

  @override
  void initState() {
    super.initState();
    for (var t in _techs) {
      _times[t] = null;
      _notes[t] = '';
    }
  }

  Future<void> _pickTime(String tech) async {
    final t = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (t != null) setState(() => _times[tech] = t);
  }

  String _randomMsg(String time) {
    final msg = _messages[Random().nextInt(_messages.length)];
    return msg.replaceAll('{time}', time);
  }

  void _notifyAll() {
    for (var tech in _techs) {
      final t = _times[tech];
      final timeStr = t?.format(context) ?? 'لم يحدد';
      final body = t != null
          ? _randomMsg(timeStr)
          : '🌤️ دوام الغد غير محدد، نراكم بعد 10 صباحًا!';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$tech → $body')),
      );
    }
  }

  void _setAll(TimeOfDay? t) {
    setState(() {
      for (var tech in _techs) _times[tech] = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    // السماح بالتحرير للمدير أو للمشرف بعد 21:30
    final canEdit = widget.role == UserRole.admin ||
        (widget.role == UserRole.supervisor &&
            (now.hour > 21 || (now.hour == 21 && now.minute >= 30)));

    if (!canEdit &&
        (widget.role == UserRole.technician || widget.role == UserRole.assistant)) {
      return Scaffold(
        appBar: AppBar(title: const Text('📅 تحديد موعد الدوام غدًا')),
        body: const Center(child: Text('Access Denied (غير مصرح)')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('📅 تحديد موعد الدوام غدًا')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (canEdit) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _setAll(const TimeOfDay(hour: 8, minute: 0)),
                        child: const Text('Set All 08:00 للجميع'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _setAll(null),
                        child: const Text('Clear All للجميع'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              Expanded(
                child: ListView.builder(
                  itemCount: _techs.length,
                  itemBuilder: (_, i) {
                    final tech = _techs[i];
                    final t = _times[tech];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(tech),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Time: ${t?.format(context) ?? 'None'}'),
                            TextField(
                              decoration:
                                  const InputDecoration(hintText: 'ملاحظة اختياريّة'),
                              onChanged: (v) => _notes[tech] = v,
                            ),
                          ],
                        ),
                        trailing: canEdit
                            ? Row(mainAxisSize: MainAxisSize.min, children: [
                                IconButton(
                                  icon: const Icon(Icons.access_time),
                                  onPressed: () => _pickTime(tech),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => setState(() => _times[tech] = null),
                                ),
                              ])
                            : null,
                      ),
                    );
                  },
                ),
              ),
              if (canEdit)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _notifyAll,
                    child: const Text('Save & Notify (حفظ وإرسال)'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
