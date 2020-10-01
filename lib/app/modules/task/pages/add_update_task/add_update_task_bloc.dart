import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:verzel/app/shared/widgets/dialog.dart';

import '../../../../shared/auth/auth_bloc.dart';
import '../../../../shared/models/task_model.dart';
import '../../repositories/task_repository.dart';
import '../../task_bloc.dart';

class AddUpdateTaskBloc extends Disposable {
  final AuthBloc _authBloc;
  final TaskRepository _repository;

  AddUpdateTaskBloc(this._authBloc, this._repository);

  // * Stream que controla a exibição da senha
  final _validateStream = BehaviorSubject<bool>();
  Function(bool) get setValidate => _validateStream.sink.add;
  Stream<bool> get getValidate => _validateStream.stream;

  // * Stream que controla a exibição da senha
  final _finalizadoStream = BehaviorSubject<bool>();
  Function(bool) get setFinalizado => _finalizadoStream.sink.add;
  Stream<bool> get getFinalizado => _finalizadoStream.stream;

  void init(TaskModel taskModel) {
    task = taskModel;

    task ??= TaskModel();
    setFinalizado(task.finalizado == 'true' ? true : false);
  }

  // * task
  TaskModel task;

  // * Global Keys
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // * atualiza task e atualiza a lista
  Future<void> updateTask() async {
    if (!formKey.currentState.validate()) {
      return setValidate(true);
    }

    task.finalizado = _finalizadoStream.value ? 'true' : 'false';
    if (task.finalizado == 'true') {
      Get.dialog(CustomDialog(
          onPressed: () => saveTask().then((value) {
                Get.close(1);
                BotToast.showText(
                    text: 'Tarefa concluída com sucesso!',
                    contentColor: Colors.green);
              }),
          descricao: 'Deseja realmente finalizar esta tarefa?'));
    } else {
      saveTask();
    }
  }

  Future<void> saveTask() async {
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

  //* deletar task
  Future<void> deleteTask(TaskModel taskModel) async {
    await _repository.delete(taskModel.id);
    await Modular.get<TaskBloc>().getTasksUser();
    Get.back();
    BotToast.showText(
        text: 'Tarefa deletada com sucesso!', contentColor: Colors.green);
  }

  @override
  void dispose() {
    _validateStream?.close();
    _finalizadoStream?.close();
  }
}
