import 'package:bout/data/repositories/history/history_repository.dart';
import 'package:bout/data/repositories/match/match_repository.dart';
import 'package:bout/data/repositories/match/match_type.dart';
import 'package:bout/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

class HistoryViewModel {
  final HistoryRepository _historyRepository;

  final _log = Logger("HistoryViewModel");

  late final Command<BuildContext, List<Widget>> loadHistory;

  HistoryViewModel(HistoryRepository historyRepository)
    : _historyRepository = historyRepository {
    loadHistory = Command.createAsync(_retrieveHistory, initialValue: []);
  }

  Future<List<Widget>> _retrieveHistory(BuildContext context) async {
    List<Widget> widgetList = [];

    Set<Map<String, dynamic>> history = await _historyRepository.fetchHistory();

    for (Map<String, dynamic> match in history) {
      int robot = match["info.robot"];
      int matchNum = match["info.match"];
      int type = match["info.type"];
      String text = "Scouted team $robot in match ${MatchType.getName(type)} $matchNum";
      widgetList.add(InkWell(
        child: Text(text),
        onTap: () => {//TODO: Open scouting page with desired info

          _openHistoryScout(robot, matchNum, type, context)
        },
      ));
    }

    return widgetList;
  }

  void _openHistoryScout(int robot, int match, int matchType, BuildContext context) {
    context.go(Routes.scout);

  }
}