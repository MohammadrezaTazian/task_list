import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/source/data_source.dart';

class HiveTaskSource implements DataSource<TaskEntity> {
  final Box<TaskEntity> _taskBox;

  HiveTaskSource(this._taskBox);
  @override
  Future<TaskEntity> createOrUpdate(TaskEntity data) async{
    if (data.isInBox) {
      await data.save();
    } else {
      await _taskBox.add(data);
    }
    return data;
  }

  @override
  Future<void> deleteAll() async{
    await _taskBox.clear();
  }

  @override
  Future<List<TaskEntity>> getAll() async {
    final tasks = _taskBox.values.toList();
    return tasks;
  }

  @override
  Future<List<TaskEntity>> searchByKeyWord(String keyWord) async {
    final tasks = _taskBox.values
        .where((element) => element.name.contains(keyWord))
        .toList();
    return tasks;
  }
}
