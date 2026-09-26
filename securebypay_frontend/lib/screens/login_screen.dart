import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../state/auth_state.dart';
import '../widgets/auth_layout.dart';
import '../widgets/labeled_text_field.dart';
import 'signup_screen.dart';
import 'dashboard_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthState auth) async {
    final ok = await auth.login(email: _email.text.trim(), password: _password.text);
    if (ok && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return AuthLayout(
      breadcrumb: 'Sign in',
      panelHeadline: 'Effortlessly Track Your Shipments\nfrom Nigeria!',
      panelSubtext:
          'Monitor your shipments from Nigeria! Enjoy swift delivery and seamless customs processing',
      formContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Sign in to your account', style: AppTextStyles.heading),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: AppTextStyles.subheading,
              children: [
                const TextSpan(
                  text: 'Log in to Myafrimall to enjoy seamless shipping to over 300 '
                      "countries right from Nigeria. Don't have an account yet? ",
                ),
                TextSpan(
                  text: 'Sign Up',
                  style: AppTextStyles.link,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const SignupScreen()),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (auth.errorMessage != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFDECEA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                auth.errorMessage!,
                style: const TextStyle(color: AppColors.danger, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
          ],
          LabeledTextField(
            label: 'Email',
            hint: 'user@example.com',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            errorText: auth.fieldErrors?['email'],
          ),
          const SizedBox(height: 18),
          LabeledTextField(
            label: 'Password',
            hint: 'Enter Password',
            controller: _password,
            obscureText: _obscure,
            errorText: auth.fieldErrors?['password'],
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ForgotPasswordScreen(
                      initialEmail: _email.text.trim(),
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text('Forgot Password?', style: AppTextStyles.link),
            ),
          ),
          const SizedBox(height: 16),
         
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 180,
              height: 48,
              child: ElevatedButton(
                onPressed: auth.isLoading ? null : () => _submit(auth),
                child: auth.isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Login'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: AppTextStyles.body.copyWith(fontSize: 12, color: AppColors.textSecondary),
              children: [
                const TextSpan(text: 'By clicking on create account you agree to our '),
              
                TextSpan(text: 'privacy\npolicy', style: AppTextStyles.link),
                const TextSpan(text: ' and '),
                TextSpan(text: 'terms of use', style: AppTextStyles.link),
              ],
            ),
          ),
        ],
      ),
    );
  }
}