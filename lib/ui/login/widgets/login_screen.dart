import 'package:bout/routing/routes.dart';
import 'package:bout/ui/core/theme/dimens.dart';
import 'package:bout/ui/login/view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController(
    text: 'email@example.com',
  );
  final TextEditingController _password = TextEditingController(
    text: 'password',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: Dimens.of(context).edgeInsetsScreenSymmetric,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(controller: _email),
                const SizedBox(height: Dimens.paddingVertical),
                TextField(controller: _password, obscureText: true),
                const SizedBox(height: Dimens.paddingVertical),
                CommandBuilder(
                  command: widget.viewModel.login,
                  onError: (context, error, _, _) {
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) => showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text("Login Error"),
                              content: Text(error.toString()),
                              actions: [
                                TextButton(
                                  child: const Text('Try again'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                      ),
                    );
                    return Container();
                  },
                  onData: (context, _, _) {
                    context.go(Routes.home);
                    return Container();
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: widget.viewModel.login.canExecute,
                  builder: (context, canExecute, _) {
                    // Depending on the value of canExecute we set or clear the handler
                    final function =
                        canExecute
                            ? () {
                              widget.viewModel.login.execute((
                                _email.value.text,
                                _password.value.text,
                              ));
                            }
                            : null;
                    return FilledButton(
                      onPressed: function,
                      child:
                          canExecute
                              ? Text("Login")
                              : CircularProgressIndicator(),
                    );
                  },
                ),
                const SizedBox(height: Dimens.paddingVertical),
                FilledButton(
                  onPressed: () => context.go(Routes.signup),
                  child: Text("New User?"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
