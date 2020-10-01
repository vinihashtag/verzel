import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../shared/auth/auth_bloc.dart';
import '../../shared/models/task_model.dart';
import 'repositories/task_repository.dart';

class TaskBloc extends Disposable {
  final AuthBloc _authBloc;
  final TaskRepository _repository;

  TaskBloc(this._authBloc, this._repository) {
    getTasksUser();
  }

  // * Controla a lista de tasks
  final _tasksStream = BehaviorSubject<List<TaskModel>>();
  Function(List<TaskModel>) get setTasks =>
      _tasksStream.isClosed ? (v) => v : _tasksStream.add;
  Stream<List<TaskModel>> get getTasks => _tasksStream.stream;
  List<TaskModel> get tasks => _tasksStream.value ?? [];

  // * busca as tasks do usuário logado
  Future<void> getTasksUser() async {
    var tasks = await _repository.getTasksUser(_authBloc.user.id);
    setTasks(tasks);
  }

  //* deletar task
  Future<void> deleteTask(TaskModel taskModel) async {
    await _repository.delete(taskModel.id);
    await Modular.get<TaskBloc>().getTasksUser();
    Get.back();
    BotToast.showText(
        text: 'Tarefa deletada com sucesso!', contentColor: Colors.green);
  }

  // * concluir tarefa
  Future<void> updateTask(TaskModel task) async {
    task.finalizado = 'true';
    if (task.finalizado == 'true' && task.dataConclusao.isEmpty) {
      task.dataConclusao = DateFormat('dd/MM/yyyy').format(DateTime.now());
    }
    if (task?.id == null) {
      task.userId = _authBloc.user.id;
      await _repository.insert(task);
    } else {
      await _repository.update(task);
    }
    await Modular.get<TaskBloc>().getTasksUser();
    Get.back();
    BotToast.showText(
        text: task?.id == null
            ? 'Tarefa criada com sucesso!'
            : 'Tarefa atualizada com sucesso!',
        contentColor: Colors.green);
  }

  @override
  void dispose() {
    _tasksStream?.close();
  }
}
