import 'package:bout/ui/scout/view_models/scout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_command/flutter_command.dart';

class PrematchPage extends StatefulWidget {
  const PrematchPage({super.key, required this.viewModel});

  final ScoutViewModel viewModel;

  @override
  State<PrematchPage> createState() => _PrematchPageState();
}

class _PrematchPageState extends State<PrematchPage> {
  late final Command<int, void> _matchSet;
  late final Command<void, int?> _matchGet;
  late final Command<void, int?> _robotGet;
  late final Command<int, void> _robotSet;

  @override
  void initState() {
    super.initState();
    _matchGet = widget.viewModel.getRetrievalCommand("info.match");
    _robotGet = widget.viewModel.getRetrievalCommand("info.robot");

    _matchSet = widget.viewModel.getSetCommand("info.match");
    _robotSet = widget.viewModel.getSetCommand("info.robot");
    
    _matchGet.execute();
    _robotGet.execute();
  }
  
  @override
  void didUpdateWidget(PrematchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    _matchGet.execute();
    _robotGet.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Prematch"),
            Text("Match Number"),
            CommandBuilder(command: _matchGet, onData: (context, result, param) {
              return TextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: result.toString()),
                onChanged:
                    (value) => _matchSet.execute(int.parse(value.isEmpty ? "0" : value)),
              );
            },),
            Text("Robot Number"),
            CommandBuilder(command: _robotGet, onData: (context, result, param) {
              return TextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: result.toString()),
                onChanged:
                    (value) => _robotSet.execute(int.parse(value.isEmpty ? "0" : value)),
              );
            },),
          ],
        ),
      ),
    );
  }
}
