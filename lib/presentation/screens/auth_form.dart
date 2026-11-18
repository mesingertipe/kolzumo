import 'package:flutter/material.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/form_validation.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 1500,
              height: 200,
              child: Image.asset(
                'assets/images/logo-kolzumo-1.png',
                width: 100,
                height: 100,
              ),
            ),
            const Text(
              'Iniciar sesión',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            FormValidation(),
          ],
        ),
      ),
    );
  }
}

