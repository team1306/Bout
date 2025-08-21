import 'package:bout/data/repositories/history/history_repository.dart';
import 'package:bout/data/repositories/match/match_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

class HistoryViewModel {
  final HistoryRepository _historyRepository;

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
      String text = "Scouted team ${match["info.robot"]} in match ${MatchType.getName(match["info.type"])} ${match["info.match"]}";

      widgetList.add(InkWell(
        child: Text(text),
        onTap: () => {},
      ));
    }

    return widgetList;
  }
}