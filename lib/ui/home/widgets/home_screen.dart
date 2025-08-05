// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bout/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:go_router/go_router.dart';

import '../view_models/home_viewmodel.dart';

const String bookingButtonKey = 'booking-button';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: CommandBuilder(
          command: widget.viewModel.load,
          onError: (context, error, _, _) {
            SchedulerBinding.instance.addPostFrameCallback(
                  (_) => showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                  title: Text("Home loading Error"),
                  content: Text(error.toString()),
                  actions: [
                    TextButton(
                      child: const Text('Try again'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.viewModel.load.execute();
                      },
                    ),
                  ],
                ),
              ),
            );
            return Container();
          },
          whileExecuting: (context, _, _) => CircularProgressIndicator(),
          onSuccess: (context, _) => Column(
            children: [
              Text(widget.viewModel.user?.name ?? "Error"),
              FilledButton(
                onPressed: () => context.go(Routes.scout),
                child: Text("Scout a match"),
              ),
              FilledButton(
                onPressed: () => context.go(Routes.history),
                child: Text("See history"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
