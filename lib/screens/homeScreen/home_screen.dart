import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/screens/editTask/edit_task.dart';
import 'package:task_list/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
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
                  setState(() {
                    searchText = value;
                  });
                },
              ),
            ]),
          ),
          Expanded(
            child: Consumer<Repository<TaskEntity>>(
              builder: (context, repository, child) {
                return FutureBuilder<List<TaskEntity>>(
                  future: repository.searchByKeyWord(searchText),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No tasks found.'));
                    } else {
                      return TaskList(tasks: snapshot.data!);
                    }
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tasks,
  });

  final List<TaskEntity> tasks;

  @override
  Widget build(BuildContext context) {
    final repository =
        Provider.of<Repository<TaskEntity>>(context, listen: false);

    return ListView.builder(
      itemCount: tasks.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Today'),
              MaterialButton(
                onPressed: () async {
                  await repository.deleteAll();
                },
                child: const Text('DeleteAll'),
              )
            ],
          );
        } else {
          return TaskItem(task: tasks[index - 1]);
        }
      },
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(taskEntity: widget.task),
            ),
          );
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
              InkWell(
                onTap: () {
                  setState(() {
                    widget.task.isComplete = !widget.task.isComplete;
                  });
                },
                child: MyCheckBox(widget.task.isComplete),
              ),
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
