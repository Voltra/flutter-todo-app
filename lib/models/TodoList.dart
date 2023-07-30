import 'package:flutter_todo_app/models/TodoItem.dart';
import 'package:quickeydb/configs/data_access_object.dart';
import 'package:quickeydb/quickeydb.dart';

class TodoList {
  int? id;
  String name;
  DateTime? createdAt;
  List<TodoItem>? items;

  static get query => QuickeyDB.getInstance!<TodoListSchema>();

  TodoList({
    this.id,
    required this.name,
    this.createdAt,
    this.items,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'created_at': createdAt?.toIso8601String(),
        'items': items?.map((item) => item.toMap()).toList(),
      };

  Map<String, dynamic> toTableMap() => {
        'id': id,
        'name': name,
        'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
      };

  TodoList.fromMap(Map<String?, dynamic> map)
      : id = map['id'],
        name = map['name'],
        createdAt = map['created_at'] != null
            ? DateTime.parse(map['created_at'])
            : null,
        items = map['items'] != null
            ? (map['items'] as List<Map<String?, dynamic>>)
                .map(TodoItem.fromMap)
                .toList()
            : null {
    items?.sort((lhs, rhs) => lhs.weight.compareTo(rhs.weight));
  }
}

class TodoListSchema extends DataAccessObject<TodoList> {
  TodoListSchema()
      : super('''
        CREATE TABLE todo_lists (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          created_at TEXT NOT NULL,
        )
      ''',
            relations: [
              const HasMany<TodoItemSchema>(),
            ],
            converter: Converter(
              encode: TodoList.fromMap,
              decode: (list) => list!.toMap(),
              decodeTable: (list) => list!.toTableMap(),
            ));

  Future<List<TodoList>> getAllDesc() async {
    final result = await order(["created_at"], "DESC").all;
    return result.nonNulls.toList();
  }

  Future<TodoList?> findByIdWithItems(int id) async {
    final list = await where({"id = ?": id}).includes([TodoItemSchema]).first;
    list?.items?.sort((lhs, rhs) => lhs.weight.compareTo(rhs.weight));
    return list;
  }
}
