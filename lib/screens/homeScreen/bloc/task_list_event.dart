part of 'task_list_bloc.dart';

@immutable
sealed class TaskListEvent {}

final class TaskListStarted extends TaskListEvent {}

final class TaskListSearch extends TaskListEvent {
  final String searchTerm;

TaskListSearch({required this.searchTerm});
}
