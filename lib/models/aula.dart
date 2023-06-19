import 'package:chamada/models/dia_da_semana.dart';

class Aula {
  final String id;
  final String nome;
  final String disciplinaId;
  final DiaDaSemana diaDaSemana;
  final String horario;
  final String professor;
  final bool chamadaRealizada;
  final double? porcentagem;

  Aula({required this.id, required this.disciplinaId, required this.diaDaSemana, required this.horario, required this.nome, required this.professor, required this.chamadaRealizada, this.porcentagem});

  factory Aula.fromJson(Map<String, dynamic> json) {
    return Aula(
      id: json['id'],
      nome: json['disciplina'],
      disciplinaId: json['disciplinaId'],
      diaDaSemana: DiaDaSemana.values.byName(json['diaDaSemana']),
      horario: json['horario'].substring(0, 5),
      professor: json['professor'],
      chamadaRealizada: json['chamadaRealizada'],
      porcentagem: json['frequencia']?.toDouble()
    );
  }

  static String _translateDiaDaSemana(String diaDaSemana){
    switch(diaDaSemana){
      case "MONDAY":
        return "Segunda-Feira";
      case "TUESDAY":
        return "Terça-Feira";
      case "WEDNESDAY":
        return "Quarta-Feira";
      case "THURSDAY":
        return "Quinta-Feira";
      case "FRIDAY":
        return "Sexta-Feira";
    }

    return diaDaSemana;
  }
}
