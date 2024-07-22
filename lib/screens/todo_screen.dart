import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do/constants.dart';
import '../models/todo_model.dart';

// ignore: must_be_immutable
class ToDoScreen extends StatelessWidget {
  ToDoScreen(
      {super.key,
      required this.type,
      required this.index,
      required this.todoText});

  TextEditingController controller = TextEditingController();

  final String type;
  final int index;
  final String todoText;

  @override
  Widget build(BuildContext context) {
    type == 'update' ? controller.text = todoText : controller.text = '';
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_outlined,
            color: kBlueColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          type == 'add' ? 'Add ToDo' : 'Update ToDo',
          style: TextStyle(color: kBlueColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                  label: Text('Add Task content'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                onButtonPressed(controller.text);
                Navigator.pop(context);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(kPinkColor),
                  fixedSize: const MaterialStatePropertyAll(Size(100, 40))),
              child: Text(
                type == 'add' ? 'Add' : 'Update',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onButtonPressed(String text) {
    if (type == 'add') {
      add(text);
    } //
    else {
      update(text, index);
    }
    controller.clear();
  }

  add(String text) async {
    var box = await Hive.openBox('todo');
    Todo todo = Todo(text,false);
    box.add(todo);
  }

  update(String text, int index) async {
    var box = await Hive.openBox('todo');
    Todo todo = Todo(text,false);
    box.putAt(index, todo);
  }
}
