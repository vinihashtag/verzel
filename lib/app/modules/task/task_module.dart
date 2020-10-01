import 'package:verzel/app/modules/task/pages/add_update_task/add_update_task_page.dart';

import 'pages/add_update_task/add_update_task_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'repositories/task_repository.dart';
import 'task_bloc.dart';
import 'task_page.dart';

class TaskModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => AddUpdateTaskBloc(i(), i())),
        Bind((i) => TaskRepository()),
        Bind((i) => TaskBloc(i(), i())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => TaskPage()),
        ModularRouter('/task-detail',
            child: (_, args) => AddUpdateTaskPage(taskModel: args.data)),
      ];

  static Inject get to => Inject<TaskModule>.of();
}
