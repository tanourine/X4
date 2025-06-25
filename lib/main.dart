import 'package:flutter/material.dart';
import 'login_page.dart'; // defines UserRole
import '../widgets/drawer_menu.dart';
import 'request_page.dart';
import 'maintenance_requests_review_page.dart';
import 'attendance_page.dart';

/// الصفحة الرئيسية للتطبيق مع شريط تنقل سفلي
/// ضع الملف في `lib/pages/home_page.dart` وسجِّل المسار في `main.dart`.
class HomePage extends StatefulWidget {
  // ثابت المسار لاستخدامه في التنقل
  static const String route = '/home';

  final String username;
  final UserRole role;

  const HomePage({
    Key? key,
    required this.username,
    required this.role,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // أربع صفحات فعلية + خامس عنصر لفتح قائمة المزيد
  static const List<Widget> _pages = [
    Center(child: Text('الإشعارات')),
    RequestPage(),
    MaintenanceRequestsReviewPage(),
    AttendancePage(),
    SizedBox.shrink(),
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      _scaffoldKey.currentState?.openDrawer();
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
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

// ------------------------ main.dart ------------------------

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const currentRole = UserRole.admin;
    const currentUser = 'eng ali';

    return MaterialApp(
      title: 'الرئيسية',
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.route,
      routes: {
        LoginPage.route: (_) => const LoginPage(),
        HomePage.route: (ctx) {
          final args = ModalRoute.of(ctx)!.settings.arguments as Map<String, dynamic>;
          return HomePage(
            username: args['username'] as String,
            role: args['role'] as UserRole,
          );
        },
        // صفحات أخرى مسجلة هنا...
      },
    );
  }
}
