import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:get/get.dart';
import 'package:verzel/app/shared/widgets/custom_textfield.dart';
import 'package:verzel/app/shared/widgets/dialog.dart';

import '../../../../shared/models/task_model.dart';
import 'add_update_task_bloc.dart';

class AddUpdateTaskPage extends StatefulWidget {
  final String title;
  final TaskViewModel taskModel;
  const AddUpdateTaskPage(
      {Key key, this.title = "AddUpdateTask", @required this.taskModel})
      : super(key: key);

  @override
  _AddUpdateTaskPageState createState() => _AddUpdateTaskPageState();
}

class _AddUpdateTaskPageState
    extends ModularState<AddUpdateTaskPage, AddUpdateTaskBloc> {
  @override
  void initState() {
    controller.init(widget.taskModel.task);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: Get.back),
          title: Text(widget.taskModel.task?.id == null
              ? 'Criar Tarefa'
              : controller.task.finalizado == 'true' ||
                      widget.taskModel.modoLeitura
                  ? 'Tarefa'
                  : 'Atualizar Tarefa'),
          centerTitle: true,
          actions: [
            Visibility(
              visible: controller.task.finalizado == 'false' &&
                  widget.taskModel?.task?.id != null &&
                  !widget.taskModel.modoLeitura,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => Get.dialog(CustomDialog(
                    onPressed: () => controller
                        .deleteTask(widget.taskModel.task)
                        .then((value) => Get.back()),
                    descricao: 'Deseja realmente remover esta tarefa?')),
              ),
            ),
          ],
        ),
        body: Scaffold(
          body: AbsorbPointer(
            absorbing: widget.taskModel.modoLeitura ||
                    widget.taskModel.task.finalizado == 'true'
                ? true
                : false,
            child: StreamBuilder<bool>(
                stream: controller.getValidate,
                initialData: false,
                builder: (context, snapshot) {
                  return Form(
                    key: controller.formKey,
                    autovalidate: snapshot.data,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // * Nome da tarefa
                          CustomTextField(
                            onChanged: (v) => controller.task.nome = v.trim(),
                            autocorrect: false,
                            initialValue: controller.task.nome,
                            validator: (value) =>
                                value.isEmpty ? 'Informe nome da tarefa' : null,
                            filled: true,
                            labelText: 'Tarefa',
                            hintText: 'Nome da tarefa',
                            prefixIcon: Icon(MaterialCommunityIcons
                                .card_bulleted_settings_outline),
                          ),

                          // * Data Entrega
                          CustomTextField(
                            onChanged: (v) =>
                                controller.task.dataEntrega = v.trim(),
                            autocorrect: false,
                            initialValue: controller.task.dataEntrega,
                            keyboardType: TextInputType.datetime,
                            validator: (value) => value.trim().isEmpty
                                ? 'Informe a data de entrega'
                                : value.length < 10
                                    ? 'Data inválida'
                                    : DateTime.parse(value
                                                .split('/')
                                                .reversed
                                                .join()
                                                .replaceAll('/', '-'))
                                            .isBefore(DateTime.now())
                                        ? 'Data deve ser maior que atual'
                                        : null,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              DataInputFormatter(),
                            ],
                            filled: true,
                            labelText: 'Data Entrega',
                            hintText: '00/00/0000',
                            prefixIcon: Icon(MaterialCommunityIcons.calendar),
                          ),

                          // * Data Conclusão
                          CustomTextField(
                            onChanged: (v) =>
                                controller.task.dataConclusao = v.trim(),
                            autocorrect: false,
                            initialValue: controller.task.dataConclusao,
                            keyboardType: TextInputType.datetime,
                            validator: (value) =>
                                value.isNotEmpty && value.length < 10
                                    ? 'Data inválida'
                                    : value.isNotEmpty &&
                                            DateTime.parse(value
                                                    .split('/')
                                                    .reversed
                                                    .join()
                                                    .replaceAll('/', '-'))
                                                .isBefore(DateTime.now())
                                        ? 'Data deve ser maior que atual'
                                        : null,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              DataInputFormatter(),
                            ],
                            filled: true,
                            labelText: 'Data Conclusão',
                            hintText: '00/00/0000',
                            prefixIcon: Icon(MaterialCommunityIcons.calendar),
                          ),

                          // * Finalizado
                          Visibility(
                            visible: controller.task?.id != null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Finalizado',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54),
                                ),
                                const SizedBox(width: 8),
                                StreamBuilder<bool>(
                                    stream: controller.getFinalizado,
                                    initialData:
                                        controller.task.finalizado == 'true'
                                            ? true
                                            : false,
                                    builder: (context, snapshot) {
                                      return CupertinoSwitch(
                                          value: snapshot.data,
                                          activeColor: Get.theme.primaryColor,
                                          onChanged: controller.setFinalizado);
                                    }),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !widget.taskModel.modoLeitura &&
                                    controller.task.finalizado != 'true'
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: ProgressButton(
                                  defaultWidget: Text(
                                    widget.taskModel?.task?.id == null
                                        ? 'Salvar'
                                        : 'Atualizar',
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
                                  onPressed: controller.updateTask,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ));
  }
}
