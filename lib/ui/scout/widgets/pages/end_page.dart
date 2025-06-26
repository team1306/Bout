import 'dart:collection';
import 'dart:ui';

import 'package:bout/routing/routes.dart';
import 'package:bout/ui/scout/view_models/scout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:go_router/go_router.dart';

class EndPage extends StatefulWidget {
  const EndPage({super.key, required this.viewModel});

  final ScoutViewModel viewModel;

  @override
  State<EndPage> createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  late final Command<int?, int> _climbUpdate;
  late final Command<int?, int> _roleUpdate;
  late final Command<int?, int> _ratingUpdate;
  final TextEditingController _notes = TextEditingController();

  @override
  void initState() {
    super.initState();

    _climbUpdate = widget.viewModel.createStateUpdate("end.climb");
    _climbUpdate.execute(null);

    _roleUpdate = widget.viewModel.createStateUpdate("end.role");
    _roleUpdate.execute(null);

    _ratingUpdate = widget.viewModel.createStateUpdate("end.driver");
    //BAD-- there should be a way to ensure that the value in it is >0
    _ratingUpdate.execute(null);

    widget.viewModel.notesUpdate.executeWithFuture().then(
      (value) => _notes.text = value,
    );
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Text("End"),
            Text("Robot Climb Status"),
            ValueListenableBuilder(
              valueListenable: _climbUpdate,
              builder: (context, result, child) {
                final state = ClimbState.values[result];
                return DropdownButton(
                  items: ClimbState.entries,
                  value: state,
                  onChanged: (value) => {_climbUpdate.execute(value!.index)},
                );
              },
            ),
            Text("Main Robot Role"),
            ValueListenableBuilder(
              valueListenable: _roleUpdate,
              builder: (context, result, child) {
                final state = RobotRoles.values[result];
                return DropdownButton(
                  items: RobotRoles.entries,
                  value: state,
                  onChanged: (value) => {_roleUpdate.execute(value!.index)},
                );
              },
            ),
            Text("Driver Rating"),
            ValueListenableBuilder(
              valueListenable: _ratingUpdate,
              builder: (context, result, child) {
                return Slider(
                  value: clampDouble(result.floorToDouble(), 1, 5),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  onChanged: (double value) {
                    _ratingUpdate.execute(value.floor());
                  },
                );
              },
            ),
            Text("Notes"),
            ValueListenableBuilder(
              valueListenable: widget.viewModel.notesUpdate,
              builder: (context, result, child) {
                return TextField(
                  controller: _notes,
                  onChanged:
                      (value) => widget.viewModel.notesUpdate.execute(value),
                );
              },
            ),
            CommandBuilder(
              command: widget.viewModel.submitMatchData,
              onError: (context, error, _, _) {
                SchedulerBinding.instance.addPostFrameCallback(
                      (_) => showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                      title: Text("Submission Error"),
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
              onData: (context, data, _) {
                if(data) context.go(Routes.home);
                return Container();
              },
            ),
            FilledButton(
              onPressed: widget.viewModel.submitMatchData.execute,
              child: Text("Submit Match"),
            ),
          ],
        ),
      ),
    );
  }
}

typedef ClimbEntry = DropdownMenuItem<ClimbState>;

enum ClimbState {
  none("None"),
  park("Park"),
  attemptedShallow("Shallow Attempt"),
  shallow("Shallow"),
  attemptedDeep("Deep Attempt"),
  deep("Deep");

  const ClimbState(this.label);

  final String label;

  static final List<ClimbEntry> entries = UnmodifiableListView<ClimbEntry>(
    values.map(
      (ClimbState state) => ClimbEntry(value: state, child: Text(state.label)),
    ),
  );
}

typedef RoleEntry = DropdownMenuItem<RobotRoles>;

enum RobotRoles {
  disabled("Disabled"),
  offense("Offense"),
  defense("Defense");

  const RobotRoles(this.label);

  final String label;

  static final List<RoleEntry> entries = UnmodifiableListView<RoleEntry>(
    values.map(
      (RobotRoles state) => RoleEntry(value: state, child: Text(state.label)),
    ),
  );
}
