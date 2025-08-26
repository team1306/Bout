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
  final MatchRepository _matchRepository;

  final _log = Logger("HistoryViewModel");

  late final Command<BuildContext, List<Widget>> loadHistory;

  HistoryViewModel(HistoryRepository historyRepository, MatchRepository matchRepository)
    : _historyRepository = historyRepository, _matchRepository = matchRepository {
    loadHistory = Command.createAsync(_retrieveHistory, initialValue: []);
  }

  Future<List<Widget>> _retrieveHistory(BuildContext context) async {
    List<Widget> widgetList = [];

    Set<Map<String, dynamic>> history = await _historyRepository.fetchHistory();

    for (Map<String, dynamic> match in history) {
      int robot = int.parse(match["info.robot"]);
      int matchNum = int.parse(match["info.match"]);
      int type = int.parse(match["info.type"]);
      String text = "Scouted team $robot in match ${MatchType.getName(type)} $matchNum";
      widgetList.add(InkWell(
        child: Text(text),
        onTap: () => _openHistoryScout(robot, matchNum, type, context)
      ));
    }

    return widgetList;
  }

  void _openHistoryScout(int robot, int match, int matchType, BuildContext context) {
    context.goNamed(Routes.scout, pathParameters: {"robot": robot.toString(), "match": match.toString(), "type": matchType.toString()});
  }
}