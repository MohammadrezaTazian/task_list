import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/screens/editTask/cubit/edit_task_cubit.dart';
import 'package:task_list/screens/editTask/edit_task.dart';
import 'package:task_list/screens/homeScreen/bloc/task_list_bloc.dart';
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
                  builder: (context) => BlocProvider(
                        create: (context) {
                          return EditTaskCubit(TaskEntity(), context.read<Repository<TaskEntity>>())
                            ..onTextChanged('')
                            ..onPeriorityChanged(Periority.low);
                        },
                        child: const EditTaskScreen(),
                      )),
            );
          },
          label: const Text('افزودن')),
      body: BlocProvider<TaskListBloc>(
        create: (context) => TaskListBloc(repository: context.read()),
        child: SafeArea(
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
                    context
                        .read<TaskListBloc>()
                        .add(TaskListSearch(searchTerm: value));
                  },
                ),
              ]),
            ),
            Expanded(
              child: Consumer<Repository<TaskEntity>>(
                builder: (context, reposutory, child) {
                  context.read<TaskListBloc>().add(TaskListStarted());

                  return BlocBuilder<TaskListBloc, TaskListState>(
                      builder: (context, state) {
                    if (state is TaskListSuccess) {
                      return TaskList(tasks: state.items);
                    } else if (state is TaskListLodding) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TaskListEmpty) {
                      return const Center(child: Text('No tasks found'));
                    } else if (state is TaskListError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(child: Text('Invalid state'));
                    }
                  });
                },
              ),
            ),
          ]),
        ),
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
              builder: (context) => BlocProvider(
                create: (context) {
                  return EditTaskCubit(
                      widget.task, context.read<Repository<TaskEntity>>())
                    ..onTextChanged(widget.task.name)
                    ..onPeriorityChanged(widget.task.periority);
                },
                child: const EditTaskScreen(),
              ),
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
