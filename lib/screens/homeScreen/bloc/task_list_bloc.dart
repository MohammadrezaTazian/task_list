import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<TaskEntity> repository;
  TaskListBloc({required this.repository}) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      try {
        final String searchTerm;
      if (event is TaskListSearch) {
        searchTerm = event.searchTerm;
      } else {
        searchTerm = '';
      }
      final items = await repository.searchByKeyWord(searchTerm);
      if (items.isEmpty) {
        emit(TaskListEmpty());
      } else {
        emit(TaskListSuccess(items));
      }
      } catch (e) {
        emit(TaskListError(e.toString()));
      }
    });
  }
}
