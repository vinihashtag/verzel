import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:verzel/app/shared/auth/auth_bloc.dart';

class CustomDialog extends StatelessWidget {
  final String descricao;
  final Function onPressed;
  final Color color;
  const CustomDialog(
      {Key key, @required this.descricao, this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${Modular.get<AuthBloc>().user.nome}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Divider(color: color ?? Get.theme.primaryColor, thickness: 2)
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Text(descricao,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      actions: <Widget>[
        FlatButton(
          child: Text("NÃO",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color ?? Get.theme.primaryColor,
              )),
          onPressed: () => Get.back(result: false),
        ),
        FlatButton(
          child: Text("SIM",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color ?? Get.theme.primaryColor,
              )),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
