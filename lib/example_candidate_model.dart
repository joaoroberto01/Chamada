import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ExampleCandidateModel {
  String nome;
  String curso;
  String ra;
  List<Color> color;

  ExampleCandidateModel({
    required this.nome,
    required this.curso,
    required this.ra,
    required this.color,
  });
}

final List<ExampleCandidateModel> candidates = [
  ExampleCandidateModel(
    nome: 'João',
    curso: 'Computação',
    ra: '20904344',
    color: const [Color(0xFFFF3868), Color(0xFFFFB49A)],
  ),
  ExampleCandidateModel(
    nome: 'Arnaldo',
    curso: 'Software',
    ra: '34545500',
    color: const [Color(0xFF736EFE), Color(0xFF62E4EC)],
  ),
  ExampleCandidateModel(
    nome: 'Sofia',
    curso: 'Filosofia',
    ra: '22331122',
    color: const [Color(0xFF2F80ED), Color(0xFF56CCF2)],
  ),
  ExampleCandidateModel(
    nome: 'Miguel',
    curso: 'Design Digital',
    ra: '17865544',
    color: const [Color(0xFF0BA4E0), Color(0xFFA9E4BD)],
  ),
];
