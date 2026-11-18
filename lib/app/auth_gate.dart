import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/initilization/session_sync_gate.dart';
import '../logic/auth_logic.dart';
import '../presentation/screens/auth_form.dart';
import '../presentation/screens/screen_home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final hasSession = context.select<Auth, bool>((auth) => auth.userAccount != null);

    if (!hasSession) {
      return const AuthForm();
    }
    return const SessionSyncGate(child: HomeApp());
  }
}