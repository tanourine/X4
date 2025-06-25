import 'package:flutter/material.dart';

/// صفحة مراجعة طلبات الأموال (Money Requests Review)
/// ضع هذا الملف تحت `lib/pages/money_requests_review_page.dart` وسجّل مساره في `main.dart`.

enum UserRole { admin, manager, technician, assistant }

/// نموذج بيانات طلب الأموال
class MoneyRequest {
  final String id;
  final String date; // YYYY-MM-DD
  final int monthNumber;
  final String monthName;
  final String type;      // نوع الطلب
  final String technician; // اسم الفني
  final String note;      // الملاحظة
  String status;          // حالياً: Pending / Approved / Rejected

  MoneyRequest({
    required this.id,
    required this.date,
    required this.monthNumber,
    required this.monthName,
    required this.type,
    required this.technician,
    required this.note,
    this.status = 'Pending (بانتظار)',
  });
}

class MoneyRequestsReviewPage extends StatefulWidget {
  static const String routeName = '/money_requests_review';

  /// دور المستخدم الحالي
  final UserRole role;

  const MoneyRequestsReviewPage({Key? key, required this.role}) : super(key: key);

  @override
  _MoneyRequestsReviewPageState createState() => _MoneyRequestsReviewPageState();
}

class _MoneyRequestsReviewPageState extends State<MoneyRequestsReviewPage> {
  // أسماء الشهور لاستخدامها في الفلترة والعرض
  final List<String> _monthNames = const [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];
  int _selectedMonth = 0; // 0 = الكل

  late List<MoneyRequest> _requests;

  @override
  void initState() {
    super.initState();
    // بيانات تجريبية
    _requests = List.generate(15, (i) {
      final monthNum = (i % 12) + 1;
      return MoneyRequest(
        id: '${i + 1}',
        date: '2025-${monthNum.toString().padLeft(2, '0')}-'
              '${(i % 28 + 1).toString().padLeft(2, '0')}',
        monthNumber: monthNum,
        monthName: _monthNames[monthNum - 1],
        type: i % 2 == 0
            ? 'Cash Request (طلب أموال كاش)'
            : 'Account Deposit (إيداع بالحساب)',
        technician: 'tech${(i % 5) + 1}',
        note: 'Note for request ${i + 1}',
      );
    });
  }

  /// قائمة الطلبات بعد تطبيق فلترة الشهر
  List<MoneyRequest> get _filtered {
    if (_selectedMonth == 0) return _requests;
    return _requests.where((r) => r.monthNumber == _selectedMonth).toList();
  }

  /// التعامل مع موافقة أو رفض الطلب
  void _respond(String id, bool approve) {
    setState(() {
      final req = _requests.firstWhere((r) => r.id == id);
      req.status = approve
          ? 'Approved (موافقة)'
          : 'Rejected (رفض)';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          approve
              ? 'Request $id approved'
              : 'Request $id rejected',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // حماية العرض: المدير العام فقط
    if (widget.role != UserRole.admin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Review Money Requests (مراجعة طلبات الأموال)'),
        ),
        body: const Center(child: Text('Access Denied (غير مصرح لك بالدخول)')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Money Requests (مراجعة طلبات الأموال)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search (بحث)',
            onPressed: () {
              // TODO: فتح حقل البحث
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter (فلترة)',
            onPressed: () {
              // TODO: فلترة متقدمة
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown لفلترة الشهر
            DropdownButtonFormField<int>(
              value: _selectedMonth,
              decoration: const InputDecoration(
                labelText: 'Filter by Month (فلترة بالشهر)',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(value: 0, child: Text('0 - All Months (كل الأشهر)')),
                for (int i = 0; i < 12; i++)
                  DropdownMenuItem(
                    value: i + 1,
                    child: Text('${i + 1} - ${_monthNames[i]}'),
                  ),
              ],
              onChanged: (v) => setState(() => _selectedMonth = v!),
            ),
            const SizedBox(height: 16),
            // قائمة الطلبات
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text('No requests found (لا توجد طلبات)'))
                  : ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) {
                        final r = _filtered[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text('Request ${r.id}  (${r.type})'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date: ${r.date}'),
                                Text('Technician: ${r.technician}'),
                                Text('Note: ${r.note}'),
                                Text('Status: ${r.status}'),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  tooltip: 'Approve (موافقة)',
                                  onPressed: r.status == 'Pending (بانتظار)'
                                      ? () => _respond(r.id, true)
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  tooltip: 'Reject (رفض)',
                                  onPressed: r.status == 'Pending (بانتظار)'
                                      ? () => _respond(r.id, false)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
