import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/widgets/add_button.dart';
import 'package:todo_app/widgets/confirmation_dialog.dart';
import 'package:todo_app/widgets/custom_dialog.dart';
import 'package:todo_app/widgets/task_listtile.dart';

enum TaskFilter {
  ALLTASKS,
  COMPLETEDTASKS,
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CalendarController calendarController = CalendarController();
  bool completedTasks = false;

  @override
  void initState() {
    Provider.of<TaskProvider>(
      context,
      listen: false,
    ).fetchTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, tasks, child) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          actions: [
            AddButton(
                icon: Icons.add,
                onTap: () => showBarModalBottomSheet(
                    context: context, builder: (context) => AddTaskScreen())),
            PopupMenuButton(onSelected: (TaskFilter selectedValue) {
              if (selectedValue == TaskFilter.ALLTASKS) {
                setState(() => completedTasks = false);
              } else
                setState(() => completedTasks = true);
            }, itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('All Tasks'),
                  value: TaskFilter.ALLTASKS,
                ),
                PopupMenuItem(
                  child: Text('Completed Tasks'),
                  value: TaskFilter.COMPLETEDTASKS,
                ),
              ];
            })
          ],
          title: Text(tasks.appBarTitle(completedTasks)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Today'),
                  SizedBox(
                    width: 8,
                  ),
                  Text(DateFormat.yMd().format(DateTime.now())),
                ],
              ),
            ),
            Expanded(
                flex: 4,
                child: tasks.taskList.isEmpty
                    ? Center(
                        child: Text(
                          'No task added',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: tasks.getTasksLength(completedTasks),
                        itemBuilder: (context, index) {
                          final task = tasks.taskList[index];
                          return Card(
                            color: Color(0xff301d8f),
                            child: Dismissible(
                                confirmDismiss: (direction) => showDialog(
                                    context: context,
                                    builder: (context) => ConfirmDialog()),
                                key: ValueKey(task.id),
                                background: Center(
                                  child: Text(
                                    'DELETE',
                                    style: TextStyle(
                                        color: Theme.of(context).errorColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onDismissed: (direction) {
                                  tasks.deleteTask(task.id);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.green,
                                    action: SnackBarAction(
                                        textColor: Colors.white,
                                        label: 'UNDO',
                                        onPressed: () =>
                                            tasks.restoreTaskByUndo(task)),
                                    content: Text('Task successfully deleted',
                                        style: TextStyle(color: Colors.white)),
                                  ));
                                },
                                child: TaskListTile(
                                  task: task,
                                )),
                          );
                        }))
          ],
        ),
      ),
    );
  }
}
