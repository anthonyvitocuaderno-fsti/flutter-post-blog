import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/presentation/shared/navigation/navigation_service.dart';

import 'login_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
          }

          NavigationService.navigateIfNeeded(state.navigationParams, source: 'LoginScreen');
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            final isLoading = state.status == LoginStatus.loading;

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (state.status == LoginStatus.failure && state.errorMessage != null) ...[
                            Text(
                              state.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                          ] else if (state.status == LoginStatus.success) ...[
                            const Text(
                              'Success! Redirecting…',
                              style: TextStyle(color: Colors.green),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                          ],
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(labelText: 'Email'),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Password'),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    final email = emailController.text.trim();
                                    final password = passwordController.text.trim();
                                    context.read<LoginBloc>().add(LoginRequested(email: email, password: password));
                                  },
                            child: isLoading
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Log in'),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              context.read<LoginBloc>().add(const NavigateToRegisterRequested());
                            },
                            child: const Text('Create account'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<LoginBloc>().add(const ContinueAsGuestRequested());
                            },
                            child: const Text('Continue as guest'),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

