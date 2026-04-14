import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/strings.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authProvider.notifier).register(
          displayName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (_, next) {
      if (next.hasValue && next.value != null) {
        context.go('/home');
      }
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(S.createAccount, style: AppTextStyles.screenTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 24),
                AppTextField(
                  controller: _nameController,
                  label: S.displayName,
                  prefixIcon: const Icon(Icons.person_outlined),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return S.nameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _emailController,
                  label: S.email,
                  hint: S.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return S.emailRequired;
                    }
                    if (!value.contains('@')) return S.emailInvalid;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  label: S.password,
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.passwordRequired;
                    }
                    if (value.length < 6) {
                      return S.passwordTooShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: S.createAccount,
                  onPressed: _register,
                  isLoading: authState.isLoading,
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: S.signUpApple,
                  icon: Icons.apple,
                  onPressed: () =>
                      ref.read(authProvider.notifier).signInWithApple(),
                  isLoading: authState.isLoading,
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    S.hasAccount,
                    style: AppTextStyles.label.copyWith(color: AppColors.accent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
