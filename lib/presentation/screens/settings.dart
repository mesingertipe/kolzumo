import 'package:flutter/material.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/menu_burguer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(currentRoute: '/settings'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Privacy'),
            ),
            ListTile(
              leading: Icon(Icons.palette),
              title: Text('Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
