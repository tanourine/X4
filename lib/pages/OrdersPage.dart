import 'package:flutter/material.dart';

/// Ready-to-use OrdersPage for a real Flutter project.
/// Place this file under `lib/pages/orders_page.dart` and register its route in `main.dart`.

enum UserRole { admin, manager, technician, assistant }

class OrdersPage extends StatefulWidget {
  static const String routeName = '/orders';
  final UserRole role;

  const OrdersPage({Key? key, required this.role}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // Admin input controllers
  final _custNameCtrl = TextEditingController();
  final _custPhoneCtrl = TextEditingController();
  final _villaCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  DateTime _appointment = DateTime.now();
  String? _selectedTech;
  final _techs = ['tech1', 'tech2', 'tech3'];

  // Sample orders for manager/technician
  final List<Map<String, dynamic>> _orders = List.generate(5, (i) {
    return {
      'id': i + 1,
      'title': 'طلب رقم \${i + 1}',
      'status': 'بانتظار',
    };
  });

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _appointment,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d != null) setState(() => _appointment = d);
  }

  void _submitOrder() {
    if (_custNameCtrl.text.trim().isEmpty ||
        _custPhoneCtrl.text.trim().isEmpty ||
        _selectedTech == null ||
        _locationCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول الأساسية')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
        'تم إنشاء الطلب لفني \$_selectedTech\n'
        'عميل: \${_custNameCtrl.text}\n'
        'فيلا: \${_villaCtrl.text.isEmpty ? "—" : _villaCtrl.text}\n'
        'موعد: \${_appointment.toLocal().toString().split(' ')[0]}'
      )),
    );
    // Clear fields
    _custNameCtrl.clear();
    _custPhoneCtrl.clear();
    _villaCtrl.clear();
    _locationCtrl.clear();
    setState(() => _selectedTech = null);
  }

  void _respondToOrder(int id, bool accept) {
    setState(() {
      final order = _orders.firstWhere((o) => o['id'] == id);
      order['status'] = accept ? 'موافق' : 'مرفوض';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
        'تم \${accept ? "الموافقة على" : "رفض"} الطلب رقم \$id'
      )),
    );
  }

  @override
  void dispose() {
    _custNameCtrl.dispose();
    _custPhoneCtrl.dispose();
    _villaCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == UserRole.admin;
    return Scaffold(
      appBar: AppBar(title: const Text('الأوردرات')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isAdmin
              // Admin UI: create order form
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _custNameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'اسم الزبون',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _custPhoneCtrl,
                        decoration: InputDecoration(
                          labelText: 'رقم الزبون',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.contacts),
                            onPressed: () {
                              // Simulate contact pick
                              setState(() {
                                _custNameCtrl.text = 'أحمد علي';
                                _custPhoneCtrl.text = '0551234567';
                              });
                            },
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _villaCtrl,
                        decoration: const InputDecoration(
                          labelText: 'رقم الفيلا (اختياري)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedTech,
                        decoration: const InputDecoration(
                          labelText: 'اختر الفني',
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
                          labelText: 'رابط موقع الفيلا (Google Maps)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'موعد الطلب: \${_appointment.toLocal().toString().split(' ')[0]}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _pickDate,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _submitOrder,
                          child: const Text('إنشاء الطلب'),
                        ),
                      ),
                    ],
                  ),
                )
              // Manager/Technician UI: view and respond to orders
              : _orders.isEmpty
                  ? const Center(child: Text('لا توجد طلبات'))
                  : ListView.builder(
                      itemCount: _orders.length,
                      itemBuilder: (_, i) {
                        final o = _orders[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(o['title']),
                            subtitle: Text('الحالة: \${o['status']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  onPressed: o['status'] == 'بانتظار'
                                      ? () => _respondToOrder(o['id'], true)
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: o['status'] == 'بانتظار'
                                      ? () => _respondToOrder(o['id'], false)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
