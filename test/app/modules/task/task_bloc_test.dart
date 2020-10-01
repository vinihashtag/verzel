import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verzel/app/app_module.dart';
import 'package:verzel/app/modules/task/task_bloc.dart';
import 'package:verzel/app/modules/task/task_module.dart';
import 'package:verzel/app/shared/models/task_model.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(TaskModule());
  TaskBloc bloc;
  TaskModel task;

  setUp(() {
    bloc = TaskModule.to.get<TaskBloc>();
    task = TaskModel(
        nome: 'Task 1',
        dataEntrega: '10/10/2020',
        finalizado: 'false',
        userId: 1);
  });

  group('TaskBloc Test', () {
    test("Valida instancia", () {
      expect(bloc, isInstanceOf<TaskBloc>());
    });

    test("Concluir Tarefa", () {
      bloc.updateTask(task);
      expect(bloc.tasks.length, 1);
    });
  });
}
