import 'pages/attendance_page.dart';

MaterialApp(
  routes: {
    AttendancePage.routeName: (_) => AttendancePage(
      role: UserRole.technician, // اختر الدور ديناميكياً من جلسة المستخدم
      userName: 'Ahmed Ali',      // أو استخرج اسم المستخدم من التنبيه
    ),
    // باقي المسارات...
  },
);
