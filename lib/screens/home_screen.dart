import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do/screens/todo_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
import '../models/todo_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: Icon(
          Icons.menu_outlined,
          color: kBlueColor,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Icon(Icons.search, color: kBlueColor),
          const SizedBox(
            width: 20,
          ),
          Icon(
            CupertinoIcons.bell,
            color: kBlueColor,
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          myNavigator(context, 'add', 0, '');
        },
        backgroundColor: kPinkColor,
        child: const Icon(
          CupertinoIcons.plus,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What`s up! Matin',
                style: TextStyle(fontSize: 35),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Today`s task',
                style: TextStyle(fontSize: 20, color: kBlueColor),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: Hive.openBox('todo'),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return todoList();
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget todoList() {
    Box todoBox = Hive.box('todo');
    List<Todo> isDoneList = [];
    List<Todo> todoList = [];
    for (var item in todoBox.values) {
      if (item.isDone) {
        isDoneList.add(item);
      } //
      else {
        todoList.add(item);
      }
    }
    return ValueListenableBuilder(
      valueListenable: todoBox.listenable(),
      builder: (context, Box box, child) {
        if (box.values.isEmpty) {
          return const Center(
            child: Text('No data!'),
          );
        } //
        else {
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: todoBox.length,
                          itemBuilder: (context, index) {
                            final Todo todo = box.getAt(index);
                            // if(todoList.isEmpty){
                            //   return Container();
                            // }
                            if (!todo.isDone) {
                              return GestureDetector(
                                onTap: () {
                                  myNavigator(
                                      context, 'update', index, todo.text);
                                },
                                child: Card(
                                  shape: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  color: kDarkBlueColor,
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: IconButton(
                                        onPressed: () {
                                          if (todo.isDone == false) {
                                            Todo isDoneTodo =
                                                Todo(todo.text, true);
                                            box.putAt(index, isDoneTodo);
                                          } //
                                          else {
                                            Todo isDoneTodo =
                                                Todo(todo.text, false);
                                            box.putAt(index, isDoneTodo);
                                          }
                                        },
                                        icon: Icon(todo.isDone
                                            ? Icons.check_circle
                                            : CupertinoIcons.circle),
                                      ),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        todo.text,
                                        style: TextStyle(
                                            decoration: todo.isDone == true
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none),
                                      ),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        remove(index);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Is Done Tasks',
                          style: TextStyle(fontSize: 20, color: kBlueColor),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: todoBox.length,
                            itemBuilder: (context, index) {
                              final Todo todo = box.getAt(index);
                              // if(todoList.isEmpty){
                              //   return Container();
                              // }
                              if (todo.isDone) {
                                return GestureDetector(
                                  onTap: () {
                                    myNavigator(
                                        context, 'update', index, todo.text);
                                  },
                                  child: Card(
                                    shape: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    color: kDarkBlueTransparentColor,
                                    child: ListTile(
                                      leading: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: IconButton(
                                          onPressed: () {
                                            if (todo.isDone == false) {
                                              Todo isDoneTodo =
                                                  Todo(todo.text, true);
                                              box.putAt(index, isDoneTodo);
                                            } //
                                            else {
                                              Todo isDoneTodo =
                                                  Todo(todo.text, false);
                                              box.putAt(index, isDoneTodo);
                                            }
                                          },
                                          icon: Icon(todo.isDone
                                              ? Icons.check_circle
                                              : CupertinoIcons.circle),
                                        ),
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          todo.text,
                                          style: TextStyle(
                                              decoration: todo.isDone == true
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        ),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          remove(index);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ));
        }
      },
    );
  }

  void myNavigator(context, String text, int index, String todoText) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ToDoScreen(type: text, index: index, todoText: todoText),
      ),
    );
  }

  void remove(int index) {
    Box box = Hive.box('todo');
    box.deleteAt(index);
  }
}
