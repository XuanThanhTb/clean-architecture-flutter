import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/foldable.dart';
import '../../bloc/login/login_cubit.dart';
import '../../bloc/login/login_state.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../widgets/responsive_layout.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<LoginCubit>();
      if (cubit.state.email.isNotEmpty && cubit.state.password.isNotEmpty) {
        _emailController.text = cubit.state.email;
        _passwordController.text = cubit.state.password;
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildResponsiveContent(BuildContext context) {
    final foldableInfo = FoldableHelper.getFoldableInfo(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop =
        Responsive.isDesktop(context) || Responsive.isLargeDesktop(context);

    // Foldable unfolded - use dual pane layout
    if (foldableInfo.isFoldable && !foldableInfo.isFolded) {
      return Row(
        children: [
          Expanded(
            child: _buildLoginForm(context, isTablet: true),
          ),
          Container(
            width: 1,
            color: Theme.of(context).dividerColor,
            margin: const EdgeInsets.symmetric(vertical: 32),
          ),
          Expanded(
            child: _buildWelcomeContent(context),
          ),
        ],
      );
    }

    // Desktop - side by side layout
    if (isDesktop) {
      return Row(
        children: [
          Expanded(
            child: _buildWelcomeContent(context),
          ),
          const SizedBox(width: 48),
          Expanded(
            flex: 1,
            child: _buildLoginForm(context, isTablet: true),
          ),
        ],
      );
    }

    // Tablet - centered with more width
    if (isTablet) {
      return Center(
        child: SizedBox(
          width: 500,
          child: _buildLoginForm(context, isTablet: true),
        ),
      );
    }

    // Mobile - single column
    return _buildLoginForm(context, isTablet: false);
  }

  Widget _buildWelcomeContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.lock_outline,
          size: Responsive.isMobile(context) ? 60 : 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 32),
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: Responsive.isMobile(context) ? 28 : 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Sign in to continue to your account',
          style: TextStyle(
            fontSize: Responsive.isMobile(context) ? 14 : 18,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 32),
        _buildFeatureList(context),
      ],
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    final features = [
      'Secure authentication',
      'Multi-device support',
      'Cloud sync',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                feature,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoginForm(BuildContext context, {required bool isTablet}) {
    final padding = FoldableHelper.getFoldablePadding(context);

    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (Responsive.isMobile(context)) ...[
                Icon(
                  Icons.lock_outline,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
              ],
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
                onChanged: (value) {
                  context.read<LoginCubit>().emailChanged(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                hint: 'Enter your password',
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outlined),
                onChanged: (value) {
                  context.read<LoginCubit>().passwordChanged(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Remember me'),
                    value: state.rememberMe,
                    onChanged: (value) {
                      context
                          .read<LoginCubit>()
                          .toggleRememberMe(value ?? false);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              ),
              const SizedBox(height: 32),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return CustomButton(
                    text: 'Sign In',
                    onPressed: state.isSubmitting
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginCubit>().login(
                                    _emailController.text.trim(),
                                    _passwordController.text,
                                  );
                            }
                          },
                    isLoading: state.isSubmitting,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: SafeArea(
        child: MaxWidthContainer(
          child: _buildResponsiveContent(context),
        ),
      ),
    );
  }
}
