import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../models/country.dart';
import '../state/auth_state.dart';
import '../widgets/auth_layout.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/phone_number_field.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  Country _selectedCountry = kDefaultCountry;
  bool _obscure = true;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthState auth) async {
    final fullPhone = '${_selectedCountry.dialCode}${_phone.text.trim()}';
    final ok = await auth.signup(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      email: _email.text.trim(),
      phoneNumber: fullPhone,
      password: _password.text,
    );
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please sign in to continue.'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return AuthLayout(
      breadcrumb: 'Sign up',
      panelHeadline: 'Seamlessly Delivering to Over\n300 Countries from Nigeria!',
      panelSubtext:
          'Access global markets with our quick shipping from Nigeria! Fast delivery and easy customs to 300+ countries.',
      formContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Create an account', style: AppTextStyles.heading),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: AppTextStyles.subheading,
              children: [
                const TextSpan(
                  text: 'Sign up for Myafrimall and gain unlimited access to '
                      'shipping to over 300 countries from Nigeria. Do you already have an account? ',
                ),
                TextSpan(
                  text: 'Login',
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LabeledTextField(
                  label: 'First name',
                  hint: 'John',
                  controller: _firstName,
                  errorText: auth.fieldErrors?['firstName'],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: LabeledTextField(
                  label: 'Last name',
                  hint: 'Doe',
                  controller: _lastName,
                  errorText: auth.fieldErrors?['lastName'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LabeledTextField(
            label: 'Email',
            hint: 'user@example.com',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            errorText: auth.fieldErrors?['email'],
          ),
          const SizedBox(height: 18),
          Text('Phone Number', style: AppTextStyles.label),
          const SizedBox(height: 6),
          PhoneNumberField(
            controller: _phone,
            initialCountry: _selectedCountry,
            onCountryChanged: (c) => setState(() => _selectedCountry = c),
            errorText: auth.fieldErrors?['phoneNumber'],
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
          const SizedBox(height: 24),
          // Reduced width per design feedback — button now hugs its
          // label instead of stretching across the full form width.
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
                    : const Text('Create account'),
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