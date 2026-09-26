import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'state/auth_state.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const SecureByPayApp());
}


class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class SecureByPayApp extends StatelessWidget {
  const SecureByPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthState(),
      child: MaterialApp(
        title: 'SecureByPay',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        scrollBehavior: AppScrollBehavior(),
        home: const _Root(),
      ),
    );
  }
}

/// Decides whether to show the login screen or the dashboard,
/// restoring a saved session (token) on first load.
class _Root extends StatefulWidget {
  const _Root();

  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  bool _checkedSession = false;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    await context.read<AuthState>().restoreSession();
    setState(() => _checkedSession = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_checkedSession) {
      return const Scaffold(
        backgroundColor: Color(0xFF141414),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    final auth = context.watch<AuthState>();
    return auth.isLoggedIn ? const DashboardScreen() : const LoginScreen();
  }
}