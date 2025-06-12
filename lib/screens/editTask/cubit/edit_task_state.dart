part of 'edit_task_cubit.dart';

@immutable
sealed class EditTaskState {
  final TaskEntity taskEntity;

  const EditTaskState({required this.taskEntity});
}

final class EditTaskInitial extends EditTaskState {
  const EditTaskInitial({required super.taskEntity});
}
final class EditTaskPeriorityChanged extends EditTaskState {
  const EditTaskPeriorityChanged({required super.taskEntity});
}
