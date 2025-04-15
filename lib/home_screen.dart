import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data.dart';
import 'package:task_list/edit_task.dart';
import 'package:task_list/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Task>(taskBoxName);
    return Scaffold(
      backgroundColor: Colors.blue,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditTask()),
            );
          },
          label: const Text('label')),
      body: ListView.builder(
        itemCount: box.values.length,
        itemBuilder: (context, index) {
          return Text(box.values.toList()[index].name);
        },
      ),
    );
  }
}
