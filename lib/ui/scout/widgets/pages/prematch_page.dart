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
  late final Command<int?, int> _matchUpdate;
  late final Command<int?, int> _robotUpdate;

  @override
  void initState() {
    super.initState();

    _matchUpdate = widget.viewModel.createStateUpdate("info.match");
    _matchUpdate.execute(null);

    _robotUpdate = widget.viewModel.createStateUpdate("info.robot");
    _robotUpdate.execute(null);
  }
  
  @override
  void didUpdateWidget(PrematchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _matchUpdate.execute(null);
    _robotUpdate.execute(null);
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
            ValueListenableBuilder(
              valueListenable: _matchUpdate,
              builder: (context, result, child) {
                return TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: result.toString()),
                  onChanged:
                      (value) => widget.viewModel
                          .createStateSet("info.match")
                          .execute(int.parse(value.isEmpty ? "0" : value)),
                );
              },
            ),
            Text("Robot Number"),
            ValueListenableBuilder(
              valueListenable: _robotUpdate,
              builder: (context, result, child) {
                return TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: result.toString()),
                  onChanged:
                      (value) => widget.viewModel
                      .createStateSet("info.robot")
                      .execute(int.parse(value.isEmpty ? "0" : value)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
