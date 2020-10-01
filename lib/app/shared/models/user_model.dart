import 'dart:convert';

class UserModel {
  int id;
  String nome;
  String email;
  String dataNascimento;
  String cpf;
  String cep;
  String endereco;
  String numero;
  String senha;
  UserModel({
    this.id,
    this.nome = '',
    this.email = '',
    this.dataNascimento = '',
    this.cpf = '',
    this.cep = '',
    this.endereco = '',
    this.numero = '',
    this.senha = '',
  });

  UserModel copyWith({
    int id,
    String nome,
    String email,
    String dataNascimento,
    String cpf,
    String cep,
    String endereco,
    String numero,
    String senha,
  }) {
    return UserModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      cpf: cpf ?? this.cpf,
      cep: cep ?? this.cep,
      endereco: endereco ?? this.endereco,
      numero: numero ?? this.numero,
      senha: senha ?? this.senha,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'data_nascimento': dataNascimento,
      'cpf': cpf,
      'cep': cep,
      'endereco': endereco,
      'numero': numero,
      'senha': senha,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserModel(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      dataNascimento: map['data_nascimento'],
      cpf: map['cpf'],
      cep: map['cep'],
      endereco: map['endereco'],
      numero: map['numero'],
      senha: map['senha'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UsuarioModel(id: $id, nome: $nome, email: $email, dataNascimento: $dataNascimento, cpf: $cpf, cep: $cep, endereco: $endereco, numero: $numero, senha: $senha)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserModel &&
        o.id == id &&
        o.nome == nome &&
        o.email == email &&
        o.dataNascimento == dataNascimento &&
        o.cpf == cpf &&
        o.cep == cep &&
        o.endereco == endereco &&
        o.numero == numero &&
        o.senha == senha;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        email.hashCode ^
        dataNascimento.hashCode ^
        cpf.hashCode ^
        cep.hashCode ^
        endereco.hashCode ^
        numero.hashCode ^
        senha.hashCode;
  }
}
