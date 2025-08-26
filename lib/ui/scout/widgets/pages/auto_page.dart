import 'package:bout/ui/core/widgets/error_indicator.dart';
import 'package:bout/ui/scout/view_models/scout_viewmodel.dart';
import 'package:bout/ui/scout/widgets/incrementer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

class AutoPage extends StatefulWidget {
  const AutoPage({super.key, required this.viewModel});

  final ScoutViewModel viewModel;

  @override
  State<AutoPage> createState() => _AutoPageState();
}

class _AutoPageState extends State<AutoPage> {
  late final Command<int?, int> _leaveUpdate;

  @override
  void initState() {
    super.initState();
    _leaveUpdate = widget.viewModel.createStateUpdate("auto.leave");
    _leaveUpdate.execute(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 15,
          children: [
            Text("Auto"),
            CommandBuilder(
              command: _leaveUpdate,
              onError:
                  (_, _, _, _) => ErrorIndicator(
                    title: "State error",
                    label: "Try Again",
                    onPressed: () => _leaveUpdate.execute(0),
                  ),
              onData:
                  (context, result, parameter) => Checkbox(
                    value: result == 1,
                    onChanged: (value) => _leaveUpdate.execute(value! ? 1 : 0),
                  ),
            ),
            Incrementer(
              title: "Auto L1",
              stateUpdate: widget.viewModel.createStateChange("auto.l1"),
            ),
            Incrementer(
              title: "Auto L2",
              stateUpdate: widget.viewModel.createStateChange("auto.l2"),
            ),
            Incrementer(
              title: "Auto L3",
              stateUpdate: widget.viewModel.createStateChange("auto.l3"),
            ),
            Incrementer(
              title: "Auto L4",
              stateUpdate: widget.viewModel.createStateChange("auto.l4"),
            ),
            Incrementer(
              title: "Auto Processor",
              stateUpdate: widget.viewModel.createStateChange("auto.process"),
            ),
            Incrementer(
              title: "Auto Net",
              stateUpdate: widget.viewModel.createStateChange("auto.net"),
            ),
          ],
        ),
      ),
    );
  }
}
