import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week10/database/taskprovider.dart';
import 'package:week10/model/task.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

List<Task> taskList = [];

class _HomeState extends State<Home> {
  final now = DateTime.now();
  TextEditingController taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tasker',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          elevation: 0,
        ),
        body: FutureBuilder<List<Task>>(
          future: TaskProvider.instance.getTask(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData) {
              taskList = snapshot.data!;
              return Column(
                children: [
                  Container(
                    height: 150,
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${now.day}',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${(DateFormat('MMMM').format(now).substring(0, 3))}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${now.year}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            '${(DateFormat('EEEE').format(now))}',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: taskList.length,
                      itemBuilder: (context, index) {
                        Task task = taskList[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: taskList[index].isChecked == true
                                ? Colors.black26
                                : null,
                            leading: Checkbox(
                              value: taskList[index].isChecked,
                              onChanged: (bool? value) async {
                                taskList[index].isChecked = value!;
                                await TaskProvider.instance.update(
                                  taskList[index],
                                );
                                setState(() {});
                              },
                            ),
                            title: Text(task.taskTitle),
                            subtitle: Text(
                              DateFormat.yMMMMEEEEd().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    task.dateTime),
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                if (task.id != null) {
                                  await TaskProvider.instance.delete(task.id!);
                                }
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.delete,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: Container(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(
                height: 100,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage:
                              AssetImage('lib/assets/1661087638451.jpg'),
                        ),
                        Text(
                          'Mohamed Abdelsalam',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  size: 25,
                ),
                title: Text(
                  'settings',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  size: 25,
                ),
                title: Text(
                  'Log out',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            DateTime? selectedDate;
            dateController.clear();
            taskController.clear();
            await showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    height: 200,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: taskController,
                            decoration: InputDecoration(
                              hintText: 'Task',
                            ),
                          ),
                          TextFormField(
                            controller: dateController,
                            onTap: () async {
                              selectedDate = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: DateTime(2015),
                                lastDate: DateTime(2050),
                              );
                              setState(() {
                                dateController
                                  ..text =
                                      DateFormat.yMMMd().format(selectedDate!)
                                  ..selection = TextSelection.fromPosition(
                                    TextPosition(
                                      offset: dateController.text.length,
                                      affinity: TextAffinity.upstream,
                                    ),
                                  );
                              });
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'Date',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'cancel',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      TaskProvider.instance.insert(
                                        Task(
                                          taskTitle: taskController.text,
                                          dateTime: selectedDate!
                                              .millisecondsSinceEpoch,
                                          isChecked: false,
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                    child: Text(
                                      'save',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              isScrollControlled: true,
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}
