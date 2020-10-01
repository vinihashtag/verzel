import 'package:verzel/app/modules/authentication/pages/register/register_page.dart';

import 'pages/register/register_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'authentication_bloc.dart';
import 'authentication_page.dart';
import 'repositories/authentication_repository.dart';

class AuthenticationModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => RegisterBloc(i(), i())),
        Bind((i) => AuthenticationBloc(i(), i())),
        Bind((i) => AuthenticationRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => AuthenticationPage()),
        ModularRouter('/register', child: (_, args) => RegisterPage()),
      ];

  static Inject get to => Inject<AuthenticationModule>.of();
}
