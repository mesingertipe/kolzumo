import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:provider/provider.dart';
import '../../../logic/auth_logic.dart';
import 'button_form.dart';

class FormValidation extends StatefulWidget {
  const FormValidation({super.key});

  @override
  State<FormValidation> createState() => _FormValidationState();
}

class _FormValidationState extends State<FormValidation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Column(
        spacing: 16,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Usuario', 
              hintText: 'Ingresa tu usuario',
              border: OutlineInputBorder(), 
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese un usuario';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Contraseña', 
              hintText: 'Ingresa tu contraseña',
              border: const OutlineInputBorder(), 
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  obscureText = !obscureText;                  
                  setState(() {});
                },
              ),
            ),
            obscureText: obscureText,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese una contraseña';
              }
              return null;
            },
          ),
          ButtonForm(
            textButton: 'Iniciar sesión',
            colorButton: AppTheme.primaryColor,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final authProvider = context.read<Auth>();
                final isLoggedIn = await authProvider.login(username: _usernameController.text, password: _passwordController.text);

                if(!context.mounted) return;
                
                if (isLoggedIn) {
                  Navigator.pushReplacementNamed(context, '/home');
                }else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Usuario o contraseña incorrectos')),
                  );
                }
              }
            },
          ),
        ],
       ),
    );
  }
}