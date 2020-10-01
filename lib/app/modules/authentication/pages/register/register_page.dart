import 'package:brasil_fields/brasil_fields.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:get/get.dart';
import 'package:verzel/app/modules/authentication/pages/register/register_bloc.dart';
import 'package:verzel/app/shared/utils/enums.dart';
import 'package:verzel/app/shared/widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  final String title;
  const RegisterPage({Key key, this.title = "Criar Conta"}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends ModularState<RegisterPage, RegisterBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: Get.back),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: StreamBuilder<StatusScreen>(
          stream: controller.getStatus,
          builder: (context, snapshot) {
            return Form(
              key: controller.formKey,
              autovalidate: snapshot.data == StatusScreen.error,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: <Widget>[
                    //* Nome
                    CustomTextField(
                      onChanged: (v) => controller.user.nome = v.trim(),
                      autocorrect: false,
                      validator: (value) =>
                          value.trim().isEmpty ? 'Informe seu nome' : null,
                      filled: true,
                      labelText: 'Nome',
                      prefixIcon: Icon(FontAwesome.user),
                    ),

                    // * Email
                    CustomTextField(
                      onChanged: (v) => controller.user.email = v.trim(),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      //autovalidate: snapshot.data == StatusScreen.error,
                      validator: (value) => value.trim().isEmpty
                          ? 'Informe seu email'
                          : EmailValidator.validate(value)
                              ? null
                              : 'Informe um email válido',
                      filled: true,
                      labelText: 'Email',
                      hintText: 'exemplo@gmail.com',
                      prefixIcon: Icon(Icons.email),
                    ),

                    // * Data Nascimento
                    CustomTextField(
                      onChanged: (v) =>
                          controller.user.dataNascimento = v.trim(),
                      autocorrect: false,
                      keyboardType: TextInputType.datetime,
                      //autovalidate: snapshot.data == StatusScreen.error,
                      validator: (value) => value.trim().isEmpty
                          ? 'Informe a data de nascimento'
                          : value.length < 10
                              ? 'Data inválida'
                              : DateTime.now().year -
                                          num.parse(value.split('/').last) <
                                      12
                                  ? 'Somente usuários maiores de 12 anos'
                                  : null,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        DataInputFormatter(),
                      ],
                      filled: true,
                      labelText: 'Data Nascimento',
                      hintText: '00/00/0000',
                      prefixIcon: Icon(MaterialCommunityIcons.calendar),
                    ),

                    // * CPF
                    CustomTextField(
                      onChanged: (v) => controller.user.cpf = v.trim(),
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      //autovalidate: snapshot.data == StatusScreen.error,
                      validator: (v) {
                        if (v.trim().isEmpty) {
                          return 'Informe o CPF';
                        } else if (!CPFValidator.isValid(v)) {
                          return 'CPF inválido';
                        } else {
                          return null;
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CpfInputFormatter(),
                      ],
                      filled: true,
                      labelText: 'CPF',
                      hintText: '000.000.000-00',
                      prefixIcon:
                          Icon(MaterialCommunityIcons.account_card_details),
                    ),

                    // * CEP
                    CustomTextField(
                      onChanged: (v) {
                        controller.user.cep = v.trim();
                        if (v.replaceAll(RegExp(r'[^\d]'), '').length == 8) {
                          controller.preencherDados(context);
                        }
                      },
                      controller: controller.cepController,
                      autocorrect: false,
                      keyboardType: TextInputType.datetime,
                      //autovalidate: snapshot.data == StatusScreen.error,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CepInputFormatter(),
                      ],
                      filled: true,
                      labelText: 'CEP',
                      hintText: '00.000-000',
                      prefixIcon: Icon(FontAwesome.location_arrow),
                    ),

                    // * Endereço
                    CustomTextField(
                      onChanged: (v) => controller.user.endereco = v.trim(),
                      autocorrect: false,
                      controller: controller.enderecoController,
                      //autovalidate: snapshot.data == StatusScreen.error,
                      filled: true,
                      labelText: 'Endereço',
                      prefixIcon: Icon(FontAwesome.address_card),
                    ),

                    // * Numero
                    CustomTextField(
                      onChanged: (v) => controller.user.numero = v.trim(),
                      autocorrect: false,
                      controller: controller.numeroController,
                      focusNode: controller.numeroFocus,
                      keyboardType: TextInputType.number,
                      //autovalidate: snapshot.data == StatusScreen.error,
                      filled: true,
                      labelText: 'Número',
                      prefixIcon: Icon(FontAwesome.address_card_o),
                    ),
                    const SizedBox(height: 12),

                    // * Senha
                    StreamBuilder<bool>(
                        stream: controller.getSenhaVisivel,
                        initialData: true,
                        builder: (context, snapshotSenha) {
                          return CustomTextField(
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (v) => controller.user.senha = v.trim(),
                            obscureText: snapshotSenha.data,
                            autocorrect: false,
                            //autovalidate: snapshot.data == StatusScreen.error,
                            validator: (value) => value.isEmpty
                                ? 'Informe sua senha'
                                : value.length < 6
                                    ? 'Senha deve conter no minimo 6 caracteres'
                                    : null,
                            onEditingComplete: () =>
                                FocusScope.of(context).unfocus(),
                            filled: true,
                            labelText: 'Senha',
                            maxLines: 1,
                            prefixIcon: Icon(FontAwesome.lock),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: IconButton(
                                  icon: Icon(!snapshotSenha.data
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () => controller
                                      .setSenhaVisivel(!snapshotSenha.data)),
                            ),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: ProgressButton(
                          defaultWidget: Text(
                            'CRIAR CONTA',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          progressWidget: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white)),
                          height: 50,
                          color: Get.theme.primaryColor,
                          onPressed: controller.signup,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
