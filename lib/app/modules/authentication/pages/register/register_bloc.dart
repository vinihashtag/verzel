import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search_cep/search_cep.dart';
import 'package:verzel/app/modules/authentication/repositories/authentication_repository.dart';
import 'package:verzel/app/shared/auth/auth_bloc.dart';
import 'package:verzel/app/shared/models/user_model.dart';
import 'package:verzel/app/shared/utils/enums.dart';
import 'package:verzel/app/shared/utils/snackbar.dart';

class RegisterBloc extends Disposable {
  final AuthBloc _authBloc;
  final AuthenticationRepository _repository;
  RegisterBloc(this._authBloc, this._repository);

  UserModel user = UserModel();

  // * Global Keys
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // * Controllers
  final TextEditingController cepController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();

  //* FocusNode
  final FocusNode numeroFocus = FocusNode();

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
  Future<void> signup() async {
    if (!formKey.currentState.validate()) {
      return setStatus(StatusScreen.error);
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setStatus(StatusScreen.loading);
    try {
      var existente = await _repository.findByEmail(user.email);
      if (existente != null) {
        setStatus(StatusScreen.error);
        return SnackBarCustom.snackBarTop(
            mensagem: 'Email já está sendo usado, crie outro!',
            icon: Icon(Icons.error_outline, color: Colors.white),
            backgroundColor: Colors.red);
      }

      user.id = await _repository.insert(user);
      if (user.id == null) {
        setStatus(StatusScreen.error);
        return SnackBarCustom.snackBarTop(
            mensagem: 'Erro ao criar usuário!',
            icon: Icon(Icons.error_outline, color: Colors.white),
            backgroundColor: Colors.red);
      }
      await Future.delayed(Duration(milliseconds: 500));
      _authBloc.user = user;
      _authBloc.setLogado(true);
      Get.offAllNamed('/task');
      BotToast.showText(text: 'Seja bem-vindo!', contentColor: Colors.green);
      // SnackBarCustom.snackSucessoTop(mensagem: 'Seja bem-vindo!');
    } on Exception catch (e) {
      print(e);
      setStatus(StatusScreen.error);
      SnackBarCustom.snackBarTop(
          mensagem: 'Erro ao fazer login!',
          icon: Icon(Icons.error_outline, color: Colors.red),
          backgroundColor: Colors.red);
    }
  }

  // * Preenche dados de endereço pelo CEP informado
  Future<bool> preencherDados(BuildContext context) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    // * Chamando loading customizado
    BotToast.showLoading(clickClose: true);

    try {
      final postmonSearchCep = ViaCepSearchCep();
      final infoCepJSON = await postmonSearchCep.searchInfoByCep(
          cep: user.cep.replaceAll(RegExp(r'[^\d]'), ''));
      if (infoCepJSON.fold((l) => null, (r) => r) != null) {
        enderecoController.text =
            infoCepJSON.fold((l) => null, (r) => r.logradouro);
        user.endereco = infoCepJSON.fold((l) => null, (r) => r.logradouro);
        FocusScope.of(formKey.currentContext).requestFocus(numeroFocus);

        return true;
      } else {
        cepController.clear();
        user.cep = '';
        enderecoController.clear();
        numeroController.clear();
        SnackBarCustom.snackBarTop(
            mensagem: 'Cep não encontrado', backgroundColor: Colors.red);

        return false;
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      SnackBarCustom.snackBarTop(
          mensagem: 'Erro ao buscar cep', backgroundColor: Colors.red);
      return false;
    } finally {
      BotToast.closeAllLoading();
    }
  }

  @override
  void dispose() {
    _statusStream?.close();
    _senhaVisivelStram?.close();
    enderecoController?.dispose();
    cepController?.dispose();
    numeroController?.dispose();
    numeroFocus?.dispose();
  }
}
