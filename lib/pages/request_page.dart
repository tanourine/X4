// Prototype Test Code with “مراجعة الطلبات” in RequestPage Dropdown
import 'package:flutter/material.dart';

void main() => runApp(const TestApp());

class TestApp extends StatelessWidget {
  const TestApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prototype',
      debugShowCheckedModeBanner: false,
      initialRoute: '/request',
      routes: {
        '/request': (_) => const RequestPage(),
        '/orders': (_) => const OrdersPage(),
        '/review': (_) => const RequestReviewPage(),
      },
    );
  }
}

/// 1) RequestPage
class RequestPage extends StatefulWidget {
  const RequestPage({super.key});
  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _noteCtrl = TextEditingController();
  String? _selectedType;
  bool _loading = false;

  final List<String> _types = [
    'طلب أموال كاش',
    'طلب سحب من بطاقة البنك',
    'طلب تحويل أموال إلى بطاقة بنك',
    'طلب دفع فاتورة',
    'إيداع كاش باليد',
    'إيداع بالحساب',
    'مراجعة الطلبات', // ← الخيار الجديد
  ];

  Future<void> _submit() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار نوع الطلب')),
      );
      return;
    }
    // Navigate immediately if "مراجعة الطلبات" selected
    if (_selectedType == 'مراجعة الطلبات') {
      Navigator.pushNamed(context, '/review');
      return;
    }
    // Otherwise require a note
    if (_noteCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى كتابة الملاحظة')),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1)); // simulate API
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال الطلب بنجاح')),
    );
    _noteCtrl.clear();
    setState(() => _selectedType = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلب'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/orders'),
            child: const Text('الأوردرات', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'نوع الطلب',
                border: OutlineInputBorder(),
              ),
              items: _types
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedType = v),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteCtrl,
              decoration: const InputDecoration(
                labelText: 'الملاحظة *',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('إرسال الطلب'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 2) OrdersPage
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context) {
    final orders = List.generate(5, (i) => 'طلب رقم ${i + 1}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأوردرات'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/review'),
            child: const Text('مراجعة الطلبات', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (_, i) => Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(orders[i]),
            subtitle: const Text('تفاصيل الطلب'),
          ),
        ),
      ),
    );
  }
}

/// 3) RequestReviewPage
class RequestReviewPage extends StatefulWidget {
  const RequestReviewPage({super.key});
  @override
  State<RequestReviewPage> createState() => _RequestReviewPageState();
}

class _RequestReviewPageState extends State<RequestReviewPage> {
  final List<String> _months = const [
    'كل الشهور',
    'يناير','فبراير','مارس','أبريل','مايو','يونيو',
    'يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'
  ];
  String? _selectedMonth = 'كل الشهور';

  @override
  Widget build(BuildContext context) {
    // sample filtered requests
    final requests = List.generate(
      10,
      (i) => 'طلب ${i + 1} لشهر $_selectedMonth',
    );
    return Scaffold(
      appBar: AppBar(title: const Text('مراجعة الطلبات')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: _selectedMonth,
              decoration: const InputDecoration(
                labelText: 'فلترة بالشهر',
                border: OutlineInputBorder(),
              ),
              items: _months
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedMonth = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (_, i) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(requests[i]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.check), onPressed: () {}),
                      IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
