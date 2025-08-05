import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

/// TODO: Class is work in progress
class HistoryViewModel {
  late final Command<void, List<Widget>> retrieveHistory;

  HistoryViewModel() {
    retrieveHistory = Command.createAsyncNoParam(_retrieveHistory, initialValue: []);
  }

  ///TODO: Replace dynamic when the type is figured out.
  Future<List<Widget>> _retrieveHistory() async {
    List<Widget> widgets = [];

    for (dynamic match in await _getMatches()) {
      Map<String, int> matchInfo = {}; //TODO get match info from match

      String text = "Match ${matchInfo["info.type"]!} ${matchInfo["info.match"]!} team ${matchInfo["info.robot"]!}";

      widgets.add(
        InkWell(
          onTap: () {
            //TODO: Make click go to filled scouting page
          },
          child: Text(
            text,
          ),
        ),
      );
    }

    return Future.value(widgets);
  }

  ///TODO: Get stored matches. Replace dynamic when you figure out the type.
  Future<List<dynamic>> _getMatches() async {
    return Future.value([]);
  }
}