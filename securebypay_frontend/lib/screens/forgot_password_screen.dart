import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../state/auth_state.dart';
import '../widgets/auth_layout.dart';
import '../widgets/labeled_text_field.dart';
import 'login_screen.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String? initialEmail;

  const ForgotPasswordScreen({super.key, this.initialEmail});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthState auth) async {
    final emailText = _email.text.trim();
    if (emailText.isEmpty) {
      return;
    }

    final result = await auth.forgotPassword(email: emailText);
    if (result.success && mounted) {
      // No inline "here's your code" box, and the code itself is no longer
      // silently pre-filled either — the user types it themselves, same as
      // they will once real email delivery exists. It's only sent straight
      // to the reset screen automatically; email is pre-filled since
      // that's just carrying forward what they already typed here.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.message.isNotEmpty ? result.message : 'Reset code sent to your email.',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            initialEmail: emailText,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return AuthLayout(
      breadcrumb: 'Forgot Password',
      panelHeadline: 'Reset Your Password\nSecurely & Easily',
      panelSubtext:
          'Get back to managing and tracking your shipments from Nigeria in just a few steps.',
      formContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Forgot your password?', style: AppTextStyles.heading),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: AppTextStyles.subheading,
              children: [
                const TextSpan(
                  text: "Enter your registered email address and we'll send you a "
                      'code to reset your password. Remembered it? ',
                ),
                TextSpan(
                  text: 'Sign In',
                  style: AppTextStyles.link,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
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
          const SizedBox(height: 24),
          SizedBox(
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
                  : const Text('Send Reset Code'),
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
            icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.primaryPurple),
            label: Text('Back to Sign in', style: AppTextStyles.link),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),
        ],
      ),
    );
  }
}