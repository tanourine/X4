import 'package:flutter/material.dart';

class MoneyRequestsReviewPage extends StatefulWidget {
  static const route = '/money-requests-review';
  const MoneyRequestsReviewPage({super.key});
  @override
  State<MoneyRequestsReviewPage> createState() => _MoneyRequestsReviewPageState();
}

class _MoneyRequestsReviewPageState extends State<MoneyRequestsReviewPage> {
  final _months = List.generate(12, (i) => i + 1);
  int? _selMonth;
  final _reqs = [
    {'id': '1/2025', 'user': 'tech1', 'type': 'Cash In Hand', 'amount': '100', 'notes': 'صيانة'},
  ];

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('مراجعة طلبات الأموال')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          DropdownButton<int>(
            hint: const Text('شهر'),
            value: _selMonth,
            items: _months.map((m) => DropdownMenuItem(value: m, child: Text('$m'))).toList(),
            onChanged: (v) => setState(() => _selMonth = v),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _reqs.length,
              itemBuilder: (_, i) {
                final r = _reqs[i];
                return Card(
                  child: ListTile(
                    title: Text('${r['user']} – ${r['type']}'),
                    subtitle: Text('Amount: ${r['amount']}  Notes: ${r['notes']}'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(content: Text('قبول ${r['id']}')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(content: Text('رفض ${r['id']}')),
                          );
                        },
                      ),
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
