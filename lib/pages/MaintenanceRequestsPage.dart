import 'package:flutter/material.dart';

/// نماذج بيانات الإشعارات
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

/// ValueNotifier لإدارة قائمة الإشعارات
final ValueNotifier<List<NotificationItem>> notificationsNotifier =
    ValueNotifier<List<NotificationItem>>([]);

/// دالة لإضافة إشعار جديد
void addNotification(NotificationItem item) {
  final list = List<NotificationItem>.from(notificationsNotifier.value);
  list.add(item);
  notificationsNotifier.value = list;
}

/// أدوار المستخدم
enum UserRole { admin, manager, technician, assistant }

/// الصفحة الرئيسية مع شريط تنقل سفلي
class MainPage extends StatefulWidget {
  static const String routeName = '/main';

  /// الدور الحالي للمستخدم
  final UserRole role;
  const MainPage({Key? key, required this.role}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      MaintenanceRequestsPage(role: widget.role),
      const NotificationsPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Requests (الطلبات)',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications (الإشعارات)',
          ),
        ],
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

/// صفحة طلبات الصيانة
class MaintenanceRequestsPage extends StatefulWidget {
  static const String routeName = '/requests';
  final UserRole role;

  const MaintenanceRequestsPage({Key? key, required this.role}) : super(key: key);

  @override
  _MaintenanceRequestsPageState createState() => _MaintenanceRequestsPageState();
}

class _MaintenanceRequestsPageState extends State<MaintenanceRequestsPage> {
  final List<Map<String, dynamic>> _requests = [];
  int _nextId = 1;
  int _currentYear = DateTime.now().year;

  final _custNameCtrl = TextEditingController();
  final _custPhoneCtrl = TextEditingController();
  final _villaCtrl = TextEditingController();
  String? _selectedTech;
  final _techs = ['tech1', 'tech2', 'tech3'];
  final _locationCtrl = TextEditingController();
  DateTime _appointment = DateTime.now();
  bool _loading = false;

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _appointment,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d != null) setState(() => _appointment = d);
  }

  void _submitRequest() async {
    final nowYear = DateTime.now().year;
    if (nowYear != _currentYear) {
      _currentYear = nowYear;
      _nextId = 1;
    }

    if (_custNameCtrl.text.trim().isEmpty ||
        _custPhoneCtrl.text.trim().isEmpty ||
        _selectedTech == null ||
        _locationCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول')),
      );
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));

    final idString = '$_nextId/$_currentYear';
    final newReq = {
      'id': idString,
      'customer': _custNameCtrl.text.trim(),
      'villa': _villaCtrl.text.trim(),
      'tech': _selectedTech,
      'location': _locationCtrl.text.trim(),
      'appointment': _appointment.toLocal().toString().split(' ')[0],
      'status': 'Pending (بانتظار)',
    };

    setState(() {
      _requests.add(newReq);
      _nextId++;
      _loading = false;
      _custNameCtrl.clear();
      _custPhoneCtrl.clear();
      _villaCtrl.clear();
      _locationCtrl.clear();
      _selectedTech = null;
      _appointment = DateTime.now();
    });

    addNotification(NotificationItem(
      title: 'New Assignment (تكليف جديد)',
      body:
          'Order $idString assigned to $_selectedTech for customer ${newReq['customer']}',
      timestamp: DateTime.now(),
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Created Request $idString')),
    );
  }

  void _respondToRequest(String id, bool accept) {
    setState(() {
      final req = _requests.firstWhere((r) => r['id'] == id);
      req['status'] = accept ? 'Approved (موافق)' : 'Rejected (مرفوض)';
    });

    addNotification(NotificationItem(
      title: accept ? 'Request Approved (تم الموافقة)' : 'Request Rejected (تم الرفض)',
      body:
          'Technician $_selectedTech ${accept ? 'approved' : 'rejected'} request $id',
      timestamp: DateTime.now(),
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          accept ? 'Approved Request $id' : 'Rejected Request $id',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == UserRole.admin;
    final isManagerOrTech = widget.role == UserRole.manager ||
        widget.role == UserRole.technician;

    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance Requests (طلبات الصيانة)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isAdmin
            ? ListView(children: [
                Text(
                  'Order Number (رقم الطلب): $_nextId/$_currentYear',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _custNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Customer Name (اسم الزبون)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _custPhoneCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Customer Phone (رقم الزبون)',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.contacts),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _villaCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Villa Number (اختياري رقم الفيلا)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedTech,
                  decoration: const InputDecoration(
                    labelText: 'Select Technician (اختر الفني)',
                    border: OutlineInputBorder(),
                  ),
                  items: _techs
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedTech = v),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _locationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Villa Location URL (رابط موقع الفيلا)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Appointment Date (موعد الصيانة): ${_appointment.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submitRequest,
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Create Request (إنشاء طلب صيانة)'),
                  ),
                ),
              ])
            : isManagerOrTech
                ? (_requests.isEmpty
                    ? const Center(child: Text('No maintenance requests (لا توجد طلبات)'))
                    : ListView.builder(
                        itemCount: _requests.length,
                        itemBuilder: (_, i) {
                          final r = _requests[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(child: Text(r['id'])),
                              title: Text('Request ${r['id']}'),
                              subtitle: Text('Status: ${r['status']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: r['status'] == 'Pending (بانتظار)'
                                        ? () => _respondToRequest(r['id'], true)
                                        : null,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: r['status'] == 'Pending (بانتظار)'
                                        ? () => _respondToRequest(r['id'], false)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ))
                : const Center(child: Text('Access Denied (غير مصرح)')),
      ),
    );
  }
}

/// صفحة الإشعارات
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications (الإشعارات)')),
      body: ValueListenableBuilder<List<NotificationItem>>(
        valueListenable: notificationsNotifier,
        builder: (context, list, _) {
          if (list.isEmpty) {
            return const Center(child: Text('No notifications (لا توجد إشعارات)'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final n = list[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(n.title),
                  subtitle: Text(n.body),
                  trailing: Text(
                    '${n.timestamp.hour.toString().padLeft(2, '0')}:${n.timestamp.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
