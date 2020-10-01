import 'package:flutter/material.dart';
import 'package:verzel/app/app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app/shared/utils/database.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //permite carregar dados dados assincronos no main()
  await DatabaseHelper.instance.database;
  runApp(ModularApp(module: AppModule()));
}
