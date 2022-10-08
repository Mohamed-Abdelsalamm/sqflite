import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:week10/model/task.dart';

final String columnId = 'id';
final String columnTaskTitle = 'taskTitle';
final String columnDateTime = 'dateTime';
final String columnIsChecked = 'isChecked';
final String taskTable = 'task_table';

class TaskProvider {
  late Database db;

  static final TaskProvider instance = TaskProvider._internal();

  factory TaskProvider() {
    return instance;
  }

  TaskProvider._internal();

  Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'todos.db'),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute('''
create table $taskTable ( 
  $columnId integer primary key autoincrement, 
  $columnTaskTitle text not null,
  $columnIsChecked integer not null,
  $columnIsChecked integer not null
  )
''');
        });
  }

  Future<Task> insert(Task task) async {
    task.id = await db.insert(taskTable, task.toMap());
    return task;
  }

  Future<List<Task>> getTask() async {
    List<Map<String, dynamic>> taskMaps = await db.query(taskTable);
    if (taskMaps.isEmpty) {
      return [];
    } else {
      List<Task> tasks = [];
      taskMaps.forEach((element) {
        tasks.add(Task.fromMap(element));
      });
      return tasks;
    }
  }

  Future<int> delete(int id) async {
    return await db.delete(taskTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future close() async => db.close();
}
