import 'package:flutter/material.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/content_profile.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/menu_burguer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(currentRoute: '/profile'),
      body: const ContentProfile(),
    );
  }
}
