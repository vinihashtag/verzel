import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:verzel/app/shared/models/user_model.dart';

class AuthBloc extends Disposable {
  // * Usuario do aplicativo
  UserModel user = UserModel();

  // * Stream que controla se o usuário está logado ou não
  final _isLoggedStream = BehaviorSubject<bool>.seeded(false);
  Function(bool) get setLogado => _isLoggedStream.sink.add;
  Stream<bool> get getLogado => _isLoggedStream.stream;

  @override
  void dispose() {
    _isLoggedStream.close();
  }
}
