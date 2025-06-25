// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'login_page.dart';                   // للتعريف بما فيّ UserRole
import '../widgets/drawer_menu.dart';
import 'request_page.dart';
import 'maintenance_requests_review_page.dart';
import 'attendance_page.dart';

class HomePage extends StatefulWidget {
  static const route = '/home';
  final String username;
  final UserRole role;
  const HomePage({
    Key? key,
    required this.username,
    required this.role,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // أربع صفحات حقيقيّة + خامس عنصر للـ “المزيد”
  static const List<Widget> _pages = [
    Center(child: Text('الإشعارات')),
    RequestPage(),                      // 1: تقديم طلب
    MaintenanceRequestsReviewPage(),    // 2: طلبات الصيانة
    AttendancePage(),                   // 3: تسجيل الدوام
    SizedBox.shrink(),                  // 4: للمزيد (يفتح الـ drawer)
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      _scaffoldKey.currentState?.openDrawer();
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('مرحباً ${widget.username}')),
      drawer: DrawerMenu(username: widget.username, role: widget.role),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'الإشعارات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'الطلبات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_circle),
            label: 'طلبات الصيانة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'الدوام',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'المزيد',
          ),
        ],
      ),
    );
  }
}
