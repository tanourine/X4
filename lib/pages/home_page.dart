class HomePage extends StatefulWidget {
  final String username;
  const HomePage({Key? key, required this.username}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onNavTap(int index) {
    // فقط لطباعة الوجهة في DartPad
    final names = ['الإشعارات', 'طلب', 'الأوردرات', 'الدوام', 'المزيد'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('انتقلت إلى: ${names[index]}')),
    );
    if (index == 4) {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // رأس الصفحة: الصورة واسم المستخدم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('اختر صورة المستخدم')),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.username,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // وسط الصفحة: الشعار
            const Expanded(
              child: Center(
                child: FlutterLogo(size: 120),
              ),
            ),
            // شريط الأزرار السفلي
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavButton(
                      icon: Icons.notifications,
                      label: 'الإشعارات',
                      onTap: () => _onNavTap(0)),
                  _NavButton(
                      icon: Icons.send,
                      label: 'طلب',
                      onTap: () => _onNavTap(1)),
                  _NavButton(
                      icon: Icons.list_alt,
                      label: 'الأوردرات',
                      onTap: () => _onNavTap(2)),
                  _NavButton(
                      icon: Icons.access_time,
                      label: 'الدوام',
                      onTap: () => _onNavTap(3)),
                  _NavButton(
                      icon: Icons.menu,
                      label: 'المزيد',
                      onTap: () => _onNavTap(4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }