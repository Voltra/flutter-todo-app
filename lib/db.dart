import 'package:flutter_todo_app/models/TodoItem.dart';
import 'package:flutter_todo_app/models/TodoList.dart';
import 'package:quickeydb/quickeydb.dart';

Future<void> initDb() async {
  await QuickeyDB.initialize(
    dbName: "flutter_todo_app",
    dbVersion: 1,
    dataAccessObjects: [
      TodoListSchema(),
      TodoItemSchema(),
    ],
  );
}
