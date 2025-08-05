// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bout/data/repositories/auth/auth_repository.dart';
import 'package:bout/ui/history/widgets/history_screen.dart';
import 'package:bout/ui/home/view_models/home_viewmodel.dart';
import 'package:bout/ui/home/widgets/home_screen.dart';
import 'package:bout/ui/login/view_models/login_viewmodel.dart';
import 'package:bout/ui/login/widgets/login_screen.dart';
import 'package:bout/ui/scout/view_models/scout_viewmodel.dart';
import 'package:bout/ui/scout/widgets/scout_screen.dart';
import 'package:bout/ui/signup/view_models/signup_viewmodel.dart';
import 'package:bout/ui/signup/widgets/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ui/history/view_models/history_view_model.dart';
import 'routes.dart';

/// Top go_router entry point.
///
/// Listens to changes in [AuthTokenRepository] to redirect the user
/// to /login when the user logs out.
GoRouter router(AuthRepository authRepository) => GoRouter(
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: authRepository,
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return LoginScreen(
          viewModel: LoginViewModel(authRepository: context.read()),
        );
      },
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        final viewModel = HomeViewModel(authRepository: context.read(), userRepository: context.read());
        return HomeScreen(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.signup,
      builder:
          (context, state) => SignupScreen(
            viewModel: SignupViewModel(authRepository: context.read()),
          ),
    ),
    GoRoute(
      path: Routes.scout,
      builder:
          (context, state) =>
              ScoutScreen(viewModel: ScoutViewModel(context.read(), context.read())),
    ),
    GoRoute(
      path: Routes.history,
      builder: (context, state) => HistoryScreen(viewModel: HistoryViewModel()),
    )
  ],
);

// From https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart
Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == Routes.login;
  final signingUp = state.matchedLocation == Routes.signup;

  if (!loggedIn) {
    // Allow access to signup and login pages
    if (signingUp || loggingIn) {
      return null; // No redirect needed
    }
    // For any other route, redirect to login
    return Routes.login;
  }

  // If user is authenticated but on login page, redirect to home
  if (loggingIn) {
    return Routes.home;
  }

  // If user is authenticated but on signup page, redirect to home
  if (signingUp) {
    return Routes.home;
  }

  // no need to redirect at all
  return null;
}
