import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verzel/app/app_module.dart';
import 'package:verzel/app/modules/task/pages/add_update_task/add_update_task_bloc.dart';
import 'package:verzel/app/modules/task/task_module.dart';
import 'package:verzel/app/shared/models/task_model.dart';
import 'package:verzel/app/shared/utils/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  Modular.init(AppModule());
  Modular.bindModule(TaskModule());
  AddUpdateTaskBloc bloc = Modular.get();
  TaskModel task;

  setUp(() {
    bloc = TaskModule.to.get<AddUpdateTaskBloc>();
    task = TaskModel(
        nome: 'Task 1',
        dataEntrega: '10/10/2020',
        finalizado: 'false',
        userId: 1);
  });

  group('AddUpdateTaskBloc Test', () {
    test("Adicionando tarefa", () async {
      bloc.task = task;
      await bloc.saveTask();
      expect(bloc.task.id, 1);
    });
  });
}
