import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

import '../view_models/history_view_model.dart';

/*
This page displays the list of matches previously scouted on this device.
Clicking on see info brings the user to a filled in scouting page with the info of that match
 */
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.viewModel});

  final HistoryViewModel viewModel;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.retrieveHistory.execute(); //Execute on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          FilledButton(
            onPressed: widget.viewModel.retrieveHistory.execute,
            child: Row(
              children: [
                Text("Refresh"),
                Icon(Icons.refresh)
              ],
            )
          ),

          CommandBuilder(
            command: widget.viewModel.retrieveHistory,

            onData: (context, data, _) => SingleChildScrollView(
              child: ListView(
                children: data
              ),
            ),

            whileExecuting: (context, command, _) => Center(child: CircularProgressIndicator()),

            onError: (context, error, command, param) => AlertDialog(
              title: Text("Error"),
              content: Text(error.toString()),
            ),
          )

        ]
      )
    );
  }
}