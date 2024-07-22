import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 1)
class Todo extends HiveObject {
  @HiveField(0)
  String text;
  @HiveField(1,defaultValue: false)
  bool isDone;

  Todo(this.text,this.isDone);
}
