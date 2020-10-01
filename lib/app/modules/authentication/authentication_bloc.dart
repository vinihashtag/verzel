import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:verzel/app/modules/authentication/repositories/authentication_repository.dart';
import 'package:verzel/app/shared/auth/auth_bloc.dart';
import 'package:verzel/app/shared/utils/enums.dart';
import 'package:verzel/app/shared/utils/snackbar.dart';

class AuthenticationBloc extends Disposable {
  final AuthBloc _authBloc;
  final AuthenticationRepository _repository;
  AuthenticationBloc(this._authBloc, this._repository);

  // * Dados para autenticação por email e senha
  String email, senha;

  // * Global Keys
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // * Stream que controla o status da tela
  final _statusStream = BehaviorSubject<StatusScreen>();
  Function(StatusScreen) get setStatus =>
      _statusStream.isClosed ? (v) => v : _statusStream.add;
  Stream<StatusScreen> get getStatus => _statusStream.stream;

  // * Stream que controla a exibição da senha
  final _senhaVisivelStram = BehaviorSubject<bool>();
  Function(bool) get setSenhaVisivel => _senhaVisivelStram.sink.add;
  Stream<bool> get getSenhaVisivel => _senhaVisivelStram.stream;

  // * Efetua o login por email e senha
  Future<void> login() async {
    if (!formKey.currentState.validate()) {
      return setStatus(StatusScreen.error);
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setStatus(StatusScreen.loading);
    try {
      // var count = await _repository.queryRowCount();
      // print("Quantidade de usuários $count");
      _authBloc.user = await _repository.findByEmail(email);
      if (_authBloc.user != null && _authBloc.user.senha == senha) {
        _authBloc.setLogado(true);
        return Get.offAllNamed('/task');
      } else {
        setStatus(StatusScreen.error);
        SnackBarCustom.snackBarTop(
            mensagem:
                'Login inválido, verifique o usuário e a senha, tente novamente!',
            icon: Icon(Icons.error_outline, color: Colors.white),
            backgroundColor: Colors.red);
        return;
      }
    } on Exception catch (e) {
      print(e);
      setStatus(StatusScreen.error);
      SnackBarCustom.snackBarTop(
          mensagem: 'Erro ao fazer login!',
          icon: Icon(Icons.error_outline, color: Colors.red),
          backgroundColor: Colors.red);
    }
  }

  @override
  void dispose() {
    _statusStream.close();
    _senhaVisivelStram.close();
  }
}
