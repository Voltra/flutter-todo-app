import 'package:flutter_todo_app/models/TodoList.dart';
import 'package:quickeydb/configs/converter.dart';
import 'package:quickeydb/configs/data_access_object.dart';
import 'package:quickeydb/quickeydb.dart';

class TodoItem {
  int? id;
  String title;
  bool completed;
  int weight;
  TodoList? todoList;

  static get query => QuickeyDB.getInstance!<TodoItemSchema>();

  TodoItem({
    this.id,
    required this.title,
    required this.completed,
    this.weight = 0,
    this.todoList,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'completed': completed,
        'weight': weight,
        'todoList': todoList?.toMap(),
      };

  Map<String, dynamic> toTableMap() => {
        'id': id,
        'title': title,
        'completed': completed,
        'weight': weight,
      };

  TodoItem.fromMap(Map<String?, dynamic> map)
      : id = map['id'],
        title = map['title'],
        completed = map['completed'],
        weight = map['weight'];
}

class TodoItemSchema extends DataAccessObject<TodoItem> {
  TodoItemSchema()
      : super('''
        CREATE TABLE todo_items (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          todo_list_id INTEGER NOT NULL,
          title TEXT NOT NULL,
          completed INTEGER DEFAULT 1 NOT NULL,
          FOREIGN KEY (todo_list_id) REFERENCES todo_lists(id)
        )
      ''',
            relations: [
              const BelongsTo<TodoListSchema>(),
            ],
            converter: Converter(
              encode: TodoItem.fromMap,
              decode: (item) => item!.toMap(),
              decodeTable: (item) => item!.toTableMap(),
            ));

  Future<List<TodoItem>> allForList(int listId) async {
    final result = await where({"todo_list_id = ?": listId}).all;
    final items = result.nonNulls.toList();
    items.sort((lhs, rhs) => lhs.weight.compareTo(rhs.weight));
    return items;
  }
}
