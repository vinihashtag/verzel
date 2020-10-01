import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:get/get.dart';
import 'package:verzel/app/modules/authentication/authentication_bloc.dart';
import 'package:verzel/app/shared/utils/enums.dart';
import 'package:verzel/app/shared/widgets/custom_textfield.dart';

class AuthenticationPage extends StatefulWidget {
  final String title;
  const AuthenticationPage({Key key, this.title = "Authentication"})
      : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState
    extends ModularState<AuthenticationPage, AuthenticationBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              children: <Widget>[
                FlutterLogo(size: 150),
                StreamBuilder<StatusScreen>(
                    stream: controller.getStatus,
                    initialData: StatusScreen.initial,
                    builder: (_, snapshot) {
                      return AbsorbPointer(
                        absorbing: snapshot.data == StatusScreen.loading,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 30),
                            CustomTextField(
                              onChanged: (v) => controller.email = v.trim(),
                              autocorrect: false,
                              filled: true,
                              autovalidate: snapshot.data == StatusScreen.error,
                              hintText: 'exemplo@gmail.com',
                              labelText: 'Email',
                              prefixIcon: Icon(FontAwesome.user_circle),
                              validator: (value) => value.isEmpty
                                  ? 'Informe seu email'
                                  : EmailValidator.validate(value)
                                      ? null
                                      : 'Informe um email válido',
                            ),
                            const SizedBox(height: 10),
                            StreamBuilder<bool>(
                                stream: controller.getSenhaVisivel,
                                initialData: true,
                                builder: (context, snapshotSenha) {
                                  return CustomTextField(
                                    keyboardType: TextInputType.visiblePassword,
                                    onChanged: (v) =>
                                        controller.senha = v.trim(),
                                    obscureText: snapshotSenha.data,
                                    autocorrect: false,
                                    autovalidate:
                                        snapshot.data == StatusScreen.error,
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
                                          onPressed: () =>
                                              controller.setSenhaVisivel(
                                                  !snapshotSenha.data)),
                                    ),
                                  );
                                }),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: ProgressButton(
                                  defaultWidget: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                  progressWidget:
                                      const CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white)),
                                  height: 50,
                                  color: Get.theme.primaryColor,
                                  onPressed: controller.login,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: SizedBox(
                                width: double.maxFinite,
                                height: 50,
                                child: OutlineButton(
                                  borderSide: BorderSide(
                                      width: 3, color: Get.theme.primaryColor),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  color: Colors.blue[300],
                                  onPressed: () => Get.toNamed('/register'),
                                  child: Text(
                                    'CADASTRAR-SE',
                                    style: TextStyle(
                                        color: Get.theme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
