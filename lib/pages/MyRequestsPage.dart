import 'package:flutter/material.dart';

/// صفحة "مراجعة طلباتي" الجاهزة للاستخدام
/// ضع هذا الملف تحت `lib/pages/my_requests_page.dart` وسجّل مساره في `main.dart`.

enum RequestStatus { pending, approved, rejected }

extension RequestStatusExtension on RequestStatus {
  String get label {
    switch (this) {
      case RequestStatus.approved:
        return 'موافق';
      case RequestStatus.rejected:
        return 'مرفوض';
      case RequestStatus.pending:
      default:
        return 'بانتظار';
    }
  }

  Color get color {
    switch (this) {
      case RequestStatus.approved:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.pending:
      default:
        return Colors.orange;
    }
  }

  IconData get icon {
    switch (this) {
      case RequestStatus.approved:
        return Icons.check_circle;
      case RequestStatus.rejected:
        return Icons.cancel;
      case RequestStatus.pending:
      default:
        return Icons.hourglass_top;
    }
  }
}

class MyRequest {
  final String title;
  final DateTime date;
  final RequestStatus status;

  MyRequest({
    required this.title,
    required this.date,
    required this.status,
  });
}

class MyRequestsPage extends StatelessWidget {
  static const String routeName = '/my_requests';

  /// نموذج بيانات لطلبات المستخدم
  final List<MyRequest> myRequests;

  const MyRequestsPage({
    Key? key,
    required this.myRequests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مراجعة طلباتي'),
      ),
      body: myRequests.isEmpty
          ? const Center(child: Text('لم تقدّم أي طلبات بعد'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myRequests.length,
              itemBuilder: (context, index) {
                final req = myRequests[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      req.status.icon,
                      color: req.status.color,
                    ),
                    title: Text(req.title),
                    subtitle: Text('التاريخ: ${req.date.toLocal().toString().split(' ')[0]}'),
                    trailing: Text(
                      req.status.label,
                      style: TextStyle(
                        color: req.status.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
