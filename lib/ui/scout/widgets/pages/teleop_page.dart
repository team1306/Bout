import 'package:bout/ui/scout/view_models/scout_viewmodel.dart';
import 'package:bout/ui/scout/widgets/incrementer.dart';
import 'package:flutter/material.dart';

class TeleopPage extends StatefulWidget{
  const TeleopPage({super.key, required this.viewModel});

  final ScoutViewModel viewModel;

  @override
  State<TeleopPage> createState() => _TeleopPageState();
}

class _TeleopPageState extends State<TeleopPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 8,
          children: [
            Text("Teleop"),
            Incrementer(
              title: "Teleop L1",
              stateUpdate: widget.viewModel.createStateChange("teleop.l1"),
            ),
            Incrementer(
              title: "Teleop L2",
              stateUpdate: widget.viewModel.createStateChange("teleop.l2"),
            ),
            Incrementer(
              title: "Teleop L3",
              stateUpdate: widget.viewModel.createStateChange("teleop.l3"),
            ),
            Incrementer(
              title: "Teleop L4",
              stateUpdate: widget.viewModel.createStateChange("teleop.l4"),
            ),
            Incrementer(
              title: "Teleop Processor",
              stateUpdate: widget.viewModel.createStateChange("teleop.process"),
            ),
            Incrementer(
              title: "Teleop Net",
              stateUpdate: widget.viewModel.createStateChange("teleop.net"),
            ),
          ],
        ),
      ),
    );
  }
}