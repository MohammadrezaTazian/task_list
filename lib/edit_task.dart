import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data.dart';
import 'package:task_list/main.dart';

class EditTask extends StatelessWidget {
  const EditTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final task = Task();
            task.name = 'test';
            task.isComplete= false;
            task.periority = Periority.low;
            if(task.isInBox){
              task.save();
            }else{
              final Box<Task> box = Hive.box(taskBoxName);
              box.add(task);
            }
          },
          label: const Text('save')),
      backgroundColor: Colors.red,
    );
  }
}
