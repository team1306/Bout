import 'package:bout/data/repositories/history/history_repository.dart';
import 'package:bout/data/repositories/match/match_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:logging/logging.dart';

class HistoryViewModel {
  final HistoryRepository _historyRepository;

  final _log = Logger("HistoryViewModel");

  late final Command<void, List<Widget>> retrieveHistory;

  HistoryViewModel(HistoryRepository historyRepository)
    : _historyRepository = historyRepository {
    retrieveHistory = Command.createAsyncNoParam(_retrieveHistory, initialValue: []);
  }

  Future<List<Widget>> _retrieveHistory() async {
    List<Widget> widgetList = [];

    Set<Map<String, dynamic>> history = await _historyRepository.fetchHistory();
    //if ()

    for (Map<String, dynamic> match in history) {
      String text = "Scouted team ${match["info.robot"]} in match ${MatchType
          .getName(int.parse(match["info.type"]))} ${match["info.match"]}";
      widgetList.add(InkWell(
        child: Text(text),
        onTap: () => {}, //TODO: Open scouting page with desired info
      ));
    }

    return widgetList;
  }
}