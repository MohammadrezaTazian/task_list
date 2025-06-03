import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data.dart';
import 'package:task_list/edit_task.dart';
import 'package:task_list/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(taskBoxName);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditTaskScreen(taskEntity: TaskEntity())),
            );
          },
          label: const Text('افزودن')),
      body: SafeArea(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Column(children: [
              AppBar(
                title: const Text('لیست وظایف'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'جستجو...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                onChanged: (value) {
                  // Add search logic here
                },
              ),
            ]),
          ),
          Expanded(
            child: ValueListenableBuilder<Box<TaskEntity>>(
              builder: (context, box, child) {
                return ListView.builder(
                  itemCount: box.values.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Today'),
                          MaterialButton(
                            onPressed: () {},
                            child: const Text('DeleteAll'),
                          )
                        ],
                      );
                    } else {
                      return TaskItem(task: box.values.toList()[index - 1]);
                    }
                  },
                );
              },
              valueListenable: box.listenable(),
            ),
          ),
        ]),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  final TaskEntity task;
  const TaskItem({
    super.key,
    required this.task,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: InkWell(
        onTap: () {
          setState(() {
            widget.task.isComplete = !widget.task.isComplete;
          });
        },
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: widget.task.periority == Periority.low
                ? Colors.red
                : widget.task.periority == Periority.high
                    ? Colors.blue
                    : Colors.yellow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyCheckBox(widget.task.isComplete),
              widget.task.isComplete
                  ? Text(
                      widget.task.name,
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough),
                    )
                  : Text(widget.task.name),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool isCompleted;

  const MyCheckBox(this.isCompleted, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isCompleted ? Theme.of(context).colorScheme.primary : Colors.white,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2.0,
        ),
      ),
      child: isCompleted
          ? Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 16.0,
            )
          : null,
    );
  }
}
