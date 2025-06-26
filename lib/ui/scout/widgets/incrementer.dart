import 'package:bout/ui/core/widgets/error_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

class Incrementer extends StatefulWidget {
  const Incrementer({
    super.key,
    required this.title, required this.stateUpdate,
  });

  final String title;
  final Command<int?, int> stateUpdate;

  @override
  State<Incrementer> createState() => _IncrementerState();
}

class _IncrementerState extends State<Incrementer> {
  
  @override
  void initState() {
    super.initState();
    widget.stateUpdate.execute(null);
  }
  
  @override
  void didUpdateWidget(Incrementer oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.stateUpdate.execute(null);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => widget.stateUpdate.execute(-1),
              child: Icon(Icons.remove),
            ),
            ValueListenableBuilder(
              valueListenable: widget.stateUpdate,
              builder: (context, result, child) {
                if (widget.stateUpdate.results.value.isExecuting) {
                  return Text("~");
                }
                
                if (widget.stateUpdate.results.value.hasError) {
                  return ErrorIndicator(
                    title: "State error",
                    label: "Try Again",
                    onPressed: () => widget.stateUpdate.execute(0),
                  );
                }
                return Text("$result");
              },
            ),
            ElevatedButton(
              onPressed: () => widget.stateUpdate.execute(1),
              child: Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
