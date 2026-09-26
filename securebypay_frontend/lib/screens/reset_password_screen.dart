import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../state/auth_state.dart';
import '../widgets/auth_layout.dart';
import '../widgets/labeled_text_field.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialToken;

  const ResetPasswordScreen({
    super.key,
    this.initialEmail,
    this.initialToken,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final TextEditingController _email;
  late final TextEditingController _token;
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.initialEmail ?? '');
    _token = TextEditingController(text: widget.initialToken ?? '');
  }

  @override
  void dispose() {
    _email.dispose();
    _token.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthState auth) async {
    setState(() => _localError = null);

    if (_newPassword.text != _confirmPassword.text) {
      setState(() => _localError = 'Passwords do not match');
      return;
    }

    if (_newPassword.text.length < 8) {
      setState(() => _localError = 'Password must be at least 8 characters long');
      return;
    }

    final result = await auth.resetPassword(
      email: _email.text.trim(),
      token: _token.text.trim(),
      newPassword: _newPassword.text,
    );

    if (result.success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final displayError = _localError ?? auth.errorMessage;

    return AuthLayout(
      breadcrumb: 'Reset Password',
      panelHeadline: 'Set Your New Password\nand Resume Shipping',
      panelSubtext:
          'Enter the reset code sent to your email and create a new secure password.',
      formContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Reset Your Password', style: AppTextStyles.heading),
          const SizedBox(height: 8),
          Text(
            'Please enter your email, the reset code received, and your new password.',
            style: AppTextStyles.subheading,
          ),
          const SizedBox(height: 24),
          if (displayError != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFDECEA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                displayError,
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
            label: 'Reset Code',
            hint: 'Enter the code from your email',
            controller: _token,
            errorText: auth.fieldErrors?['token'],
          ),
          const SizedBox(height: 18),
          LabeledTextField(
            label: 'New Password',
            hint: 'Enter New Password',
            controller: _newPassword,
            obscureText: _obscureNew,
            errorText: auth.fieldErrors?['password'],
            suffixIcon: IconButton(
              icon: Icon(_obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined),
              onPressed: () => setState(() => _obscureNew = !_obscureNew),
            ),
          ),
          const SizedBox(height: 18),
          LabeledTextField(
            label: 'Confirm New Password',
            hint: 'Re-enter New Password',
            controller: _confirmPassword,
            obscureText: _obscureConfirm,
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined),
              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
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
                  : const Text('Reset Password'),
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