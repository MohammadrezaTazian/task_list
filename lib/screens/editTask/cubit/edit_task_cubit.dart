import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  final TaskEntity _taskEntity;
  final Repository<TaskEntity> repository;
  EditTaskCubit(this._taskEntity, this.repository)
      : super(EditTaskInitial(taskEntity: _taskEntity));
  void onSaveChangedClick() {
    repository.createOrUpdate(_taskEntity);
  }

  void onTextChanged(String text) {
    _taskEntity.name = text;
  }

  void onPeriorityChanged(Periority periority) {
    _taskEntity.periority = periority;
    emit(EditTaskPeriorityChanged(taskEntity: _taskEntity));
  }
}
