import 'package:bout/ui/scout/view_models/scout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

class AutoPage extends StatefulWidget {
  const AutoPage({super.key, required this.viewModel});

  final ScoutViewModel viewModel;

  @override
  State<AutoPage> createState() => _AutoPageState();
}

class _AutoPageState extends State<AutoPage> {
  late final Command<int, void> _leaveSet;
  late final Command<void, int?> _leaveGet;

  
  @override
  void initState() {
    super.initState();
    
    _leaveSet = widget.viewModel.getSetCommand("auto.leave");
    _leaveGet = widget.viewModel.getRetrievalCommand("auto.leave");
    
    _leaveSet.addListener(_leaveGet.execute);
    
    _leaveGet.execute();
  }
  
  @override
  void didUpdateWidget(covariant AutoPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    _leaveGet.execute();
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
              command: _leaveGet,
              onData:
                  (context, result, parameter) => Checkbox(
                    value: result == 1,
                    onChanged: (value) => _leaveSet.execute(value! ? 1 : 0),
                  ),
            ),
            widget.viewModel.buildIncrementer("Auto L1", "auto.l1"),
            widget.viewModel.buildIncrementer("Auto L2", "auto.l2"),
            widget.viewModel.buildIncrementer("Auto L3", "auto.l3"),
            widget.viewModel.buildIncrementer("Auto L4", "auto.l4"),
            widget.viewModel.buildIncrementer("Auto Processor", "auto.process"),
            widget.viewModel.buildIncrementer("Auto Net", "auto.net"),
          ],
        ),
      ),
    );
  }
}
