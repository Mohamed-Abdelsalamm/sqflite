import '../database/taskprovider.dart';

class Task {
  int? id;
  late String taskTitle;
  late int dateTime;
  late bool isChecked;

  Task({
    this.id,
    required this.taskTitle,
    required this.dateTime,
    required this.isChecked,
  });

  Task.fromMap(Map<String, dynamic> data) {
    if (data[columnId] != null) this.id = data[columnId];
    this.taskTitle = data[columnTaskTitle];
    this.dateTime = data[columnDateTime];
    this.isChecked = data[columnIsChecked] == 0 ? false : true;
  }

  Map<String, dynamic> toMap() {
    Map <String , dynamic> data = {};
    if (this.id != null) data[columnId] = this.id;
    data[columnTaskTitle] = this.taskTitle;
    data[columnDateTime] = this.dateTime;
    data[columnIsChecked] = this.isChecked ? 1 : 0;
    return data;
  }
}
