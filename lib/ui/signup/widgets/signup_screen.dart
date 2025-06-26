import 'package:bout/routing/routes.dart';
import 'package:bout/ui/core/theme/dimens.dart';
import 'package:bout/ui/signup/view_models/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.viewModel});

  final SignupViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

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
                TextField(controller: _username),
                const SizedBox(height: Dimens.paddingVertical),
                TextField(controller: _email),
                const SizedBox(height: Dimens.paddingVertical),
                TextField(controller: _password, obscureText: true),
                const SizedBox(height: Dimens.paddingVertical),
                CommandBuilder(
                  command: widget.viewModel.signup,
                  onError: (context, error, _, _) {
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) => showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text("Signup Error"),
                              content: Text((error as Exception).toString()),
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
                  onData: (context, _, params) {
                    context.go(Routes.login);
                    return Container();
                  },
                ),

                const SizedBox(height: Dimens.paddingVertical),
                ValueListenableBuilder<bool>(
                  valueListenable: widget.viewModel.signup.canExecute,
                  builder: (context, canExecute, _) {
                    // Depending on the value of canExecute we set or clear the handler
                    final function =
                        canExecute
                            ? () {
                              widget.viewModel.signup.execute((
                                _username.value.text,
                                _email.value.text,
                                _password.value.text,
                              ));
                            }
                            : null;
                    return FilledButton(
                      onPressed: function,
                      child:
                          canExecute
                              ? Text("Signup")
                              : CircularProgressIndicator(),
                    );
                  },
                ),
                const SizedBox(height: Dimens.paddingVertical),
                FilledButton(
                  onPressed: () => context.go(Routes.login),
                  child: Text("Back to login"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
