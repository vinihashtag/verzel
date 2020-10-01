import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:verzel/app/app_widget.dart';
import 'package:verzel/app/modules/authentication/authentication_module.dart';
import 'package:verzel/app/shared/auth/auth_bloc.dart';

import 'app_bloc.dart';
import 'modules/task/task_module.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => AppBloc()),
        Bind((i) => AuthBloc()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, module: AuthenticationModule()),
        ModularRouter('/task', module: TaskModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
