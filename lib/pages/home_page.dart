import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String username = args['username'];
    final role = args['role'] as dynamic; // نمرر الدور حسب الحاجة

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.pushNamed(context, '/reports'),
          )
        ],
      ),
      drawer: DrawerMenu(username: username, role: role),
      body: Center(child: Text('Welcome, $username')),
    );
  }
}
