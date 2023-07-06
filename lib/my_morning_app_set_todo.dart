import 'package:flutter/material.dart';

class MyMorningAppSetTodo extends StatefulWidget {
  const MyMorningAppSetTodo({super.key, required this.onDone});
  final Function(String text, int priority) onDone;
  @override
  State<StatefulWidget> createState() => MyMorningAppSetTodoState();
}

class MyMorningAppSetTodoState extends State<MyMorningAppSetTodo> {
  late TextEditingController todoController;
  late TextEditingController priorityController;

  @override
  initState() {
    super.initState();
    todoController = TextEditingController();
    priorityController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    todoController.dispose();
    priorityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.onDone.call(
              todoController.text,
              int.parse(priorityController.text),
            );
          },
          child: Icon(Icons.done),
        ),
        body: Column(children: [
          TextField(
            controller: todoController,
          ),
          TextField(
            controller: priorityController,
          ),
        ]),
      ),
    );
  }
}
