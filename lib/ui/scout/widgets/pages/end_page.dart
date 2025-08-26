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
  late final Command<int, void> _climbSet;
  late final Command<int, void> _roleSet;
  late final Command<int, void> _ratingSet;
  late final Command<void, int?> _climbGet;
  late final Command<void, int?> _roleGet;
  late final Command<void, int?> _ratingGet;
  final TextEditingController _notes = TextEditingController();

  @override
  void initState() {
    super.initState();

    _climbSet = widget.viewModel.getSetCommand("end.climb");
    _climbGet = widget.viewModel.getRetrievalCommand("end.climb");

    _roleSet = widget.viewModel.getSetCommand("end.role");
    _roleGet = widget.viewModel.getRetrievalCommand("end.role");

    _ratingSet = widget.viewModel.getSetCommand("end.driver");
    _ratingGet = widget.viewModel.getRetrievalCommand("end.driver");

    widget.viewModel.notesGet.executeWithFuture().then(
      (value) => _notes.text = value ?? "",
    );

    _climbSet.addListener(_climbGet.execute);
    _roleSet.addListener(_roleGet.execute);
    _ratingSet.addListener(_ratingGet.execute);

    _climbGet.execute();
    _roleGet.execute();
    _ratingGet.execute();
  }

  @override
  void didUpdateWidget(covariant EndPage oldWidget) {
    _climbGet.execute();
    _roleGet.execute();
    _ratingGet.execute();
    
    super.didUpdateWidget(oldWidget);
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
            CommandBuilder(
              command: _climbGet,
              onData: (context, result, _) {
                final state = ClimbState.values[result!];
                return DropdownButton(
                  items: ClimbState.entries,
                  value: state,
                  onChanged: (value) => {_climbSet.execute(value!.index)},
                );
              },
            ),
            Text("Main Robot Role"),
            CommandBuilder(
              command: _roleGet,
              onData: (context, result, _) {
                final state = RobotRoles.values[result!];
                return DropdownButton(
                  items: RobotRoles.entries,
                  value: state,
                  onChanged: (value) => {_roleSet.execute(value!.index)},
                );
              },
            ),
            Text("Driver Rating"),
            CommandBuilder(
              command: _ratingGet,
              onData: (context, result, _) {
                return Slider(
                  value: clampDouble(result!.floorToDouble(), 1, 5),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  onChanged: (double value) {
                    _ratingSet.execute(value.floor());
                  },
                );
              },
            ),
            Text("Notes"),
            CommandBuilder(
              command: widget.viewModel.notesGet,
              onData:
                  (context, result, _) => TextField(
                    controller: _notes,
                    onChanged:
                        (value) => widget.viewModel.notesSet.execute(value),
                  ),
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
