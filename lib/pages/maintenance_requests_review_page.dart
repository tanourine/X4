import 'package:flutter/material.dart';

/// Ready-to-use Maintenance Requests Review page.
/// Place this file under `lib/pages/maintenance_requests_review_page.dart` and register its route in main.dart.

enum UserRole { admin, maintenanceManager, technician, assistant }

class MaintenanceRequestsReviewPage extends StatefulWidget {
  static const String routeName = '/maintenance_requests_review';

  /// User role (for potential access control)
  final UserRole role;

  const MaintenanceRequestsReviewPage({
    Key? key,
    required this.role,
  }) : super(key: key);

  @override
  _MaintenanceRequestsReviewPageState createState() => _MaintenanceRequestsReviewPageState();
}

class _MaintenanceRequestsReviewPageState extends State<MaintenanceRequestsReviewPage> {
  String selectedMonth = '0 - All Months (كل الأشهر)';
  String selectedStatus = 'All (الكل)';
  String selectedTech = 'All (الكل)';

  final List<String> months = [
    '0 - All Months (كل الأشهر)',
    '1 - Jan (يناير)',
    '2 - Feb (فبراير)',
    '3 - Mar (مارس)',
    '4 - Apr (أبريل)',
    '5 - May (مايو)',
    '6 - Jun (يونيو)',
    '7 - Jul (يوليو)',
    '8 - Aug (أغسطس)',
    '9 - Sep (سبتمبر)',
    '10 - Oct (أكتوبر)',
    '11 - Nov (نوفمبر)',
    '12 - Dec (ديسمبر)',
  ];

  final List<String> statuses = [
    'All (الكل)',
    'Pending (بانتظار)',
    'Approved (موافق عليه)',
    'Rejected (مرفوض)',
  ];

  final List<String> technicians = [
    'All (الكل)',
    'Ali (علي)',
    'Mohammad (محمد)',
    'Kashif (كاشف)',
  ];

  @override
  Widget build(BuildContext context) {
    // Optional: enforce access control based on role
    final canAccess = widget.role == UserRole.admin ||
        widget.role == UserRole.maintenanceManager;
    if (!canAccess) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review Requests (مراجعة الطلبات)')),
        body: const Center(child: Text('Access Denied (غير مصرح)')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Review Requests (مراجعة الطلبات)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              DropdownButton<String>(
                value: selectedMonth,
                items: months
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => setState(() => selectedMonth = v!),
                hint: const Text('Month (الشهر)'),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: selectedStatus,
                items: statuses
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => selectedStatus = v!),
                hint: const Text('Status (الحالة)'),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: selectedTech,
                items: technicians
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => selectedTech = v!),
                hint: const Text('Technician (الفني)'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  // TODO: apply filtering logic here
                },
                child: const Text('Apply (تطبيق)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
