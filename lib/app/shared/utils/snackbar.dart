import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarCustom {
  static void msgAtencao(
          {String titulo,
          String mensagem,
          IconData icon,
          Color colorCustom,
          Function onTap,
          Function onPressed}) =>
      Get.snackbar(
        titulo, // title
        mensagem,
        borderColor: Get.theme.primaryColor,
        boxShadows: [
          new BoxShadow(
            color: Colors.black,
            blurRadius: 10,
          ),
        ],
        borderWidth: 3,
        mainButton: FlatButton(
            onPressed: null,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Ver\nDetalhes',
                style: TextStyle(
                    color: Get.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            )),
        // icon: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Icon(icon ?? Icons.new_releases,
        //       color: colorCustom ?? Colors.white70),
        // ),
        onTap: onTap ?? (v) {},
        isDismissible: true,
        colorText: Colors.black,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.fromLTRB(3, 1, 3, 0),
        borderRadius: 10,
        maxWidth: 800,
        duration: Duration(seconds: 4),
      );

  static void snackSucessoTop(
          {String titulo, @required String mensagem, Icon icon}) =>
      Get.snackbar('', '',
          snackPosition: SnackPosition.TOP,
          borderRadius: 0,
          duration: Duration(seconds: 2, milliseconds: 500),
          backgroundColor: Colors.green,
          margin: EdgeInsets.zero,
          icon: Padding(padding: EdgeInsets.only(left: 8, top: 4), child: icon),
          titleText: titulo == null
              ? Container()
              : Text(
                  titulo,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
          messageText: Text(
            mensagem,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
          ));

  static void snackSucessoBottom(
          {String titulo, @required String mensagem, Icon icon}) =>
      Get.snackbar('', '',
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 0,
          duration: Duration(seconds: 2, milliseconds: 500),
          backgroundColor: Colors.green,
          margin: EdgeInsets.zero,
          icon: Padding(padding: EdgeInsets.only(left: 8, top: 4), child: icon),
          titleText: titulo == null
              ? Container()
              : Text(
                  titulo,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
          messageText: Text(
            mensagem,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
          ));

  static void snackBarBottom(
          {String titulo, @required String mensagem, Icon icon}) =>
      Get.snackbar('', '',
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 0,
          duration: Duration(seconds: 2, milliseconds: 500),
          backgroundColor: Colors.black,
          margin: EdgeInsets.zero,
          icon: icon == null
              ? null
              : Padding(padding: EdgeInsets.only(left: 8, top: 4), child: icon),
          titleText: titulo == null
              ? Container()
              : Text(
                  titulo,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
          messageText: Text(
            mensagem,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
          ));

  static void snackBarTop(
          {String titulo,
          @required String mensagem,
          Icon icon,
          Color backgroundColor}) =>
      Get.snackbar('', '',
          borderRadius: 0,
          duration: Duration(seconds: 2, milliseconds: 500),
          isDismissible: true,
          backgroundColor: backgroundColor ?? Colors.black,
          margin: EdgeInsets.zero,
          icon: icon == null
              ? null
              : Padding(padding: EdgeInsets.only(left: 8, top: 4), child: icon),
          titleText: titulo == null
              ? Container()
              : Text(
                  titulo,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
          messageText: Text(
            mensagem,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
          ));
}
