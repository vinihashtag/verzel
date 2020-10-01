import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:verzel/app/shared/widgets/dialog.dart';

import '../../shared/models/task_model.dart';
import 'task_bloc.dart';

class TaskPage extends StatefulWidget {
  final String title;
  const TaskPage({Key key, this.title = "Tarefas"}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends ModularState<TaskPage, TaskBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () => Get.offNamed('/')),
          ),
        ],
      ),
      body: StreamBuilder<List<TaskModel>>(
          stream: controller.getTasks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, size: 100, color: Colors.black54),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Erro ao buscar as tasks',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black54),
                    ),
                  ),
                ],
              ));
            }
            if (snapshot.data.isEmpty) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(MaterialCommunityIcons.file_alert_outline,
                      size: 100, color: Colors.black54),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Você não possui nenhuma task cadastrada',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black54),
                    ),
                  ),
                ],
              ));
            }
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  final task = snapshot.data[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nome tarefa',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Get.theme.primaryColor)),
                            Text(task.nome),
                          ],
                        ),
                      ),
                      subtitle: Visibility(
                        visible: task.finalizado == 'false',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Data entrega',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Get.theme.accentColor)),
                            Text(task.dataEntrega),
                          ],
                        ),
                        replacement: Text(
                          'CONCLUÍDO',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      trailing: Wrap(
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => Get.dialog(CustomDialog(
                                onPressed: () => controller.deleteTask(task),
                                descricao:
                                    'Deseja realmente remover esta tarefa?')),
                          ),
                          Visibility(
                            visible: task.finalizado != 'true' ? true : false,
                            child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => Get.toNamed(
                                    '/task/task-detail',
                                    arguments: TaskViewModel(
                                        task: task, modoLeitura: false))),
                          ),
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () => Get.toNamed('/task/task-detail',
                                arguments: TaskViewModel(
                                    task: task, modoLeitura: true)),
                          ),
                          Visibility(
                            visible: task.finalizado != 'true' ? true : false,
                            child: IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () => Get.dialog(CustomDialog(
                                  onPressed: () => controller.updateTask(task),
                                  descricao:
                                      'Deseja realmente finalizar esta tarefa?')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/task/task-detail',
              arguments: TaskViewModel(task: TaskModel(), modoLeitura: false));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
