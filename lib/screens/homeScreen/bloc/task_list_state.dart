part of 'task_list_bloc.dart';

@immutable
sealed class TaskListState {}

final class TaskListInitial extends TaskListState {}

final class TaskListLodding extends TaskListState {}

final class TaskListEmpty extends TaskListState {}

final class TaskListError extends TaskListState {
  final String message;
  TaskListError(this.message);
}

// final class TaskListSearch extends TaskListState {
//   final String searchTerm;

//   TaskListSearch({required this.searchTerm});
// }

final class TaskListSuccess extends TaskListState {
  final List<TaskEntity> items;

  TaskListSuccess(this.items);
}
