import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';
import 'login_page.dart';
import 'request_page.dart';
import 'maintenance_requests_review_page.dart';
import 'attendance_page.dart';

class HomePage extends StatefulWidget {
  // المسار الحرفي في routes: '/home'
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _username;
  late UserRole _role;
  int _selectedIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<Widget> _placeholders = [
    Center(child: Text('الإشعارات')),                   // index 0
    RequestPage(),                                      // index 1
    MaintenanceRequestsReviewPage(),                    // index 2
    AttendancePage(),                                   // index 3
    // index 4 مفتوح للقائمة الجانبية
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments 
        as Map<String, dynamic>?; 
    if (args != null) {
      _username = args['username'] as String;
      _role = args['role'] as UserRole;
    }
  }

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
      appBar: AppBar(title: Text('مرحبا $_username')),
      drawer: DrawerMenu(username: _username, role: _role),
      body: _selectedIndex < _placeholders.length
          ? _placeholders[_selectedIndex]
          : const SizedBox.shrink(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications), label: 'الإشعارات'),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page), label: 'الطلبات'),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_circle), label: 'الأوردارات'),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time), label: 'الدوام'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu), label: 'المزيد'),
        ],
      ),
    );
  }
}
