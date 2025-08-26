import 'package:bout/ui/scout/view_models/scout_viewmodel.dart';
import 'package:bout/ui/scout/widgets/pages/auto_page.dart';
import 'package:bout/ui/scout/widgets/pages/end_page.dart';
import 'package:bout/ui/scout/widgets/pages/prematch_page.dart';
import 'package:bout/ui/scout/widgets/pages/teleop_page.dart';
import 'package:flutter/material.dart';

class ScoutScreen extends StatefulWidget {
  const ScoutScreen({super.key, required this.viewModel});

  final ScoutViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _ScoutScreenState();
}

class _ScoutScreenState extends State<ScoutScreen> {
  int currentPageIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.start), label: "Prematch"),
          NavigationDestination(icon: Icon(Icons.autorenew), label: "Auto"),
          NavigationDestination(
            icon: Icon(Icons.call_received),
            label: "Teleop",
          ),
          NavigationDestination(icon: Icon(Icons.check), label: "End"),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      body: [
        PrematchPage(viewModel: widget.viewModel),
        AutoPage(viewModel: widget.viewModel),
        TeleopPage(viewModel: widget.viewModel),
        EndPage(viewModel: widget.viewModel),
      ][currentPageIndex],
    );
  }
}
