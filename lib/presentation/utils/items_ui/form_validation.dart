import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/core/config/app_config.dart';
import 'package:kolzumo_app/core/services/biometric_service.dart';
import 'package:kolzumo_app/core/services/demo_api_interceptor.dart';
import 'package:provider/provider.dart';
import '../../../logic/auth_logic.dart';

class FormValidation extends StatefulWidget {
  const FormValidation({super.key});

  @override
  State<FormValidation> createState() => _FormValidationState();
}

class _FormValidationState extends State<FormValidation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _rememberUsername = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bio = context.read<BiometricService>();
      final remembered = bio.rememberedUsername ?? bio.savedUsername;
      if (remembered != null && remembered.isNotEmpty) {
        _usernameController.text = remembered;
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitCredentials({
    required String username,
    required String password,
    bool fromBiometrics = false,
  }) async {
    setState(() => _errorMessage = null);

    final authProvider = context.read<Auth>();
    final bioService = context.read<BiometricService>();

    final result = await authProvider.authenticate(
      username: username,
      password: password,
    );

    if (!mounted) return;

    if (!result.success) {
      setState(() => _errorMessage = result.message);
      return;
    }

    if (_rememberUsername) {
      await bioService.saveRememberedUsername(username);
    } else {
      await bioService.saveRememberedUsername(null);
    }

    // Si es la primera vez que inicia sesión con clave y el dispositivo tiene biometría,
    // preguntamos si desea activar el acceso biométrico.
    if (!fromBiometrics && await bioService.shouldPromptFirstTime(username)) {
      if (!mounted) return;
      await _showFirstTimeBiometricPrompt(
        username: username,
        password: password,
      );
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _handleBiometricLogin() async {
    setState(() => _errorMessage = null);
    final bioService = context.read<BiometricService>();
    final creds = await bioService.authenticateAndGetCredentials();
    if (!mounted) return;

    if (creds == null) {
      setState(
        () => _errorMessage =
            'No se completó la verificación biométrica. Puedes ingresar con tu contraseña.',
      );
      return;
    }

    await _submitCredentials(
      username: creds.username,
      password: creds.password,
      fromBiometrics: true,
    );
  }

  Future<void> _showFirstTimeBiometricPrompt({
    required String username,
    required String password,
  }) async {
    final bioService = context.read<BiometricService>();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          icon: Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: AppTheme.secondColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fingerprint_rounded,
              size: 40,
              color: AppTheme.primaryColor,
            ),
          ),
          title: const Text(
            '¿Activar ingreso con Biometría?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
          content: const Text(
            'Puedes usar tu huella digital o reconocimiento facial para iniciar sesión en 1 segundo sin escribir tu contraseña.\n\nTambién podrás activarlo o desactivarlo cuando quieras desde el apartado de Seguridad.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () async {
                await bioService.markPrompted(username);
                if (dialogCtx.mounted) Navigator.of(dialogCtx).pop();
              },
              child: const Text('Más tarde'),
            ),
            FilledButton.icon(
              onPressed: () async {
                final activated = await bioService.enableBiometrics(
                  username: username,
                  password: password,
                );
                if (!dialogCtx.mounted) return;
                Navigator.of(dialogCtx).pop();
                if (mounted && activated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Acceso biométrico activado con éxito'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Activar ahora'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<Auth>();
    final bioService = context.watch<BiometricService>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.dangerColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.dangerColor.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppTheme.dangerColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: AppTheme.dangerColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          TextFormField(
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            enabled: !auth.isAuthenticating,
            decoration: const InputDecoration(
              labelText: 'Usuario',
              hintText: 'Ingresa tu usuario de vendedor',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa tu usuario';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            enabled: !auth.isAuthenticating,
            obscureText: _obscureText,
            onFieldSubmitted: (_) {
              if (_formKey.currentState!.validate()) {
                _submitCredentials(
                  username: _usernameController.text,
                  password: _passwordController.text,
                );
              }
            },
            decoration: InputDecoration(
              labelText: 'Contraseña',
              hintText: 'Ingresa tu contraseña',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                tooltip: _obscureText ? 'Mostrar contraseña' : 'Ocultar contraseña',
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa tu contraseña';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: _rememberUsername,
                activeColor: AppTheme.primaryColor,
                onChanged: auth.isAuthenticating
                    ? null
                    : (val) => setState(() => _rememberUsername = val ?? true),
              ),
              GestureDetector(
                onTap: auth.isAuthenticating
                    ? null
                    : () =>
                        setState(() => _rememberUsername = !_rememberUsername),
                child: const Text(
                  'Recordar mi usuario en este dispositivo',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: auth.isAuthenticating
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        _submitCredentials(
                          username: _usernameController.text,
                          password: _passwordController.text,
                        );
                      }
                    },
              icon: auth.isAuthenticating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.login_rounded),
              label: Text(
                auth.isAuthenticating ? 'Verificando acceso...' : 'Iniciar sesión',
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Botón de acceso rápido con Usuario Demo (controlado dinámicamente por Firebase / Config)
          if (context.watch<AppConfig>().demoModeEnabled)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.secondColor.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.science_outlined,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Modo Demo de Prueba',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.forestDark,
                          ),
                        ),
                        Text(
                          'Usuario: demo  •  Clave: 1234',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppTheme.forestDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: auth.isAuthenticating
                        ? null
                        : () {
                            DemoApiInterceptor.instance.activateDemoMode();
                            _usernameController.text =
                                DemoApiInterceptor.demoUsername;
                            _passwordController.text =
                                DemoApiInterceptor.demoPassword;
                            _submitCredentials(
                              username: DemoApiInterceptor.demoUsername,
                              password: DemoApiInterceptor.demoPassword,
                            );
                          },
                    child: const Text(
                      'Entrar Demo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          if (bioService.isEnabled) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade300)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'O acceso rápido',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: auth.isAuthenticating ? null : _handleBiometricLogin,
                icon: const Icon(Icons.fingerprint_rounded, size: 24),
                label: const Text(
                  'Ingresar con Huella / Face ID',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
