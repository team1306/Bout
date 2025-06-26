import 'package:bout/main_development.dart' as development;
import 'package:bout/ui/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'routing/router.dart';

void main() {
  development.main();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Command.globalExceptionHandler = (error, stackTrace) {
      Logger(error.commandName ?? "Command").fine(error.toString());
    };
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router(context.read()),
    );
  }
}
