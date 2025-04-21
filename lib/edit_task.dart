import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data.dart';
import 'package:task_list/main.dart';

class EditTaskScreen extends StatelessWidget {
  const EditTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final task = TaskEntity();
            task.name = 'test';
            task.isComplete = false;
            task.periority = Periority.low;
            if (task.isInBox) {
              task.save();
            } else {
              final Box<TaskEntity> box = Hive.box(taskBoxName);
              box.add(task);
            }
          },
          label: const Text('save')),
      backgroundColor: Colors.red,
      body: Column(
        children: [
          AppBar(
            title: const Text('ویرایش وظایف'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          const Flex(
            direction: Axis.horizontal,
          children: [
            Flexible(flex: 1, child: PeriorityCheckBox(color: Colors.blue, lable: 'high', isSelected: false)),
            Flexible(flex: 1, child: PeriorityCheckBox(color: Colors.blue, lable: 'normal', isSelected: false)),
            Flexible(flex: 1, child: PeriorityCheckBox(color: Colors.blue, lable: 'low', isSelected: false)),
          ],
          )
        ],
      ),
    );
  }
}

class PeriorityCheckBox extends StatelessWidget {
  final Color color;
  final String lable;
  final bool isSelected;

  const PeriorityCheckBox({super.key, required this.color, required this.lable, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2.0,
        ),
      ),
      child: Row(
        children: [
          Text(lable),
          if (isSelected)
            Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 16.0,
            ),
        ],
      ),
    );
  }
}
