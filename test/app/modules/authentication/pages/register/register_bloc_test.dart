import 'package:flutter_modular/flutter_modular.dart';
import 'package:verzel/app/app_module.dart';
import 'package:verzel/app/modules/authentication/authentication_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(AuthenticationModule());
  // RegisterBloc bloc;

  // setUp(() {
  //     bloc = AuthenticationModule.to.get<RegisterBloc>();
  // });

  // group('RegisterBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<RegisterBloc>());
  //   });
  // });
}
