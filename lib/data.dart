import 'package:hive_flutter/adapters.dart';
part 'data.g.dart';

@HiveType(typeId: 0)
class TaskEntity extends HiveObject {
  @HiveField(0)
  String name = '';
  @HiveField(1)
  bool isComplete = false;
  @HiveField(2)
  Periority periority = Periority.low;
}

@HiveType(typeId: 1)
enum Periority {
  @HiveField(0)
  low,
  @HiveField(1)
  normal,
  @HiveField(2)
  high,
}
