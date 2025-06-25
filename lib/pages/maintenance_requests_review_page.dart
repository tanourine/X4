import 'package:flutter/material.dart';

class MaintenanceRequestsReviewPage extends StatefulWidget {
  static const route = '/maintenance-requests';
  const MaintenanceRequestsReviewPage({super.key});
  @override
  State<MaintenanceRequestsReviewPage> createState() => _MaintenanceRequestsReviewPageState();
}

class _MaintenanceRequestsReviewPageState extends State<MaintenanceRequestsReviewPage> {
  final _months = List.generate(12, (i) => i + 1);
  int? _selectedMonth;
  final List<Map<String,String>> _reqs = [
    {
      'id': '1/2025',
      'customer': 'Ali',
      'phone': '0501234567',
      'villa': '12',
      'tech': 'tech1',
      'loc': 'https://maps.google.com',
      'when': '2025-06-20 09:00'
    },
  ];

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('مراجعة طلبات الصيانة')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          DropdownButton<int>(
            hint: const Text('شهر'),
            value: _selectedMonth,
            items: _months.map((m) => DropdownMenuItem(value: m, child: Text('$m'))).toList(),
            onChanged: (v) => setState(() => _selectedMonth = v),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _reqs.length,
              itemBuilder: (_, i) {
                final r = _reqs[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('رقم: ${r['id']}'),
                      Text('زبون: ${r['customer']} (${r['phone']})'),
                      if ((r['villa'] ?? '').isNotEmpty) Text('فيلا: ${r['villa']}'),
                      Text('فني: ${r['tech']}'),
                      TextButton(
                        onPressed: () {}, 
                        child: const Text('عرض الموقع')
                      ),
                      Text('موعد: ${r['when']}'),
                      Row(children: [
                        ElevatedButton(onPressed: () {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(content: Text('قبول الطلب ${r['id']}'))
                          );
                        }, child: const Text('Accept')),
                        const SizedBox(width: 8),
                        ElevatedButton(onPressed: () {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(content: Text('رفض الطلب ${r['id']}'))
                          );
                        }, child: const Text('Reject')),
                      ]),
                    ]),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
