import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/presentation/shared/navigation/navigation_service.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/route_paths.dart';

import 'register_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.status == RegisterStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
          }

          if (state.status == RegisterStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Registration successful! Please log in.'),
                  backgroundColor: Colors.green,
                  ),
              );
          }

          final route = state.navigationRoute;
          if (route == null) return;

          if (state.navigationRemoveUntil && state.navigationPredicate != null) {
            NavigationService.navigateToAndRemoveUntil(
              route,
              state.navigationPredicate!,
              arguments: state.navigationArguments,
            );
          } else if (state.navigationReplace) {
            NavigationService.navigateToReplacement(
              route,
              arguments: state.navigationArguments,
            );
          } else {
            NavigationService.navigateTo(
              route,
              arguments: state.navigationArguments,
            );
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            final isLoading = state.status == RegisterStatus.loading;

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
                          if (state.status == RegisterStatus.failure && state.errorMessage != null) ...[
                            Text(
                              state.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                          ] else if (state.status == RegisterStatus.success) ...[
                            const Text(
                              'Success! Redirecting…',
                              style: TextStyle(color: Colors.green),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                          ],
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(labelText: 'Name'),
                          ),
                          const SizedBox(height: 16),
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
                                    final name = nameController.text.trim();
                                    final email = emailController.text.trim();
                                    final password = passwordController.text.trim();
                                    context.read<RegisterBloc>().add(
                                          RegisterRequested(
                                            name: name,
                                            email: email,
                                            password: password,
                                          ),
                                        );
                                  },
                            child: isLoading
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Register'),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              // TODO do not bypass Bloc
                              NavigationService.navigateToAndRemoveUntil(
                                RoutePaths.login,
                                (route) => false,
                              );
                            },
                            child: const Text('Already have an account? Log in'),
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
