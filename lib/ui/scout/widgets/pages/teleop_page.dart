import 'package:bout/ui/scout/view_models/scout_viewmodel.dart';
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
          spacing: 15,
          children: [
            Text("Teleop"),
            widget.viewModel.buildIncrementer("Teleop L1", "teleop.l1"),
            widget.viewModel.buildIncrementer("Teleop L2", "teleop.l2"),
            widget.viewModel.buildIncrementer("Teleop L3", "teleop.l3"),
            widget.viewModel.buildIncrementer("Teleop L4", "teleop.l4"),
            widget.viewModel.buildIncrementer("Teleop Processor", "teleop.process"),
            widget.viewModel.buildIncrementer("Teleop Net", "teleop.net"),
          ],
        ),
      ),
    );
  }
}