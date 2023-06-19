import 'package:chamada/models/professor.dart';

class Disciplina {
  final String id;
  final String nome;
  final Professor? professor;

  Disciplina({required this.id, required this.nome, required this.professor});

  factory Disciplina.fromJson(Map<String, dynamic> json) {
    final professorData = json['professor'];

    return Disciplina(
        id: json['id'],
        nome: json['nome'],
        professor: professorData != null ? Professor.fromJson(professorData) : null
    );
  }
}
