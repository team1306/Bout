import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

class Incrementer extends StatefulWidget {
  Incrementer({
    super.key,
    required this.title,
    required this.changeState,
    required this.getState,
  }){
    changeState.addListener(getState.execute);
  }

  final String title;
  final Command<int, void> changeState;
  final Command<void, int?> getState;

  @override
  State<Incrementer> createState() => _IncrementerState();
}

class _IncrementerState extends State<Incrementer> {
  
  @override
  void initState() {
    super.initState();
    widget.getState.execute();
  }
  
  @override
  void didUpdateWidget(Incrementer oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.getState.execute();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            ElevatedButton(
              onPressed: () => widget.changeState.execute(-1),
              child: Icon(Icons.remove),
            ),
            CommandBuilder(
              command: widget.getState,
              onData: (context, result, _) => Text("$result"),
              whileExecuting: (_, _, _) => const Text("~"),
            ),
            ElevatedButton(
              onPressed: () => widget.changeState.execute(1),
              child: Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
