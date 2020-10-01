import 'dart:convert';

class TaskModel {
  int id;
  String nome;
  String dataEntrega;
  String dataConclusao;
  String finalizado;
  int userId;
  TaskModel({
    this.id,
    this.nome = '',
    this.dataEntrega = '',
    this.dataConclusao = '',
    this.userId,
    this.finalizado = 'false',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'data_entrega': dataEntrega,
      'data_conclusao': dataConclusao,
      'finalizado': finalizado,
      'user_id': userId,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TaskModel(
      id: map['id'],
      nome: map['nome'],
      dataEntrega: map['data_entrega'],
      dataConclusao: map['data_conclusao'],
      finalizado: map['finalizado'],
      userId: map['user_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TaskModel(id: $id, nome: $nome, dataEntrega: $dataEntrega, dataConclusao: $dataConclusao, finalizado: $finalizado, userId: $userId)';
  }
}

class TaskViewModel {
  TaskModel task;
  bool modoLeitura;
  TaskViewModel({
    this.task,
    this.modoLeitura,
  });
}
