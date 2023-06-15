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
    nome: 'Enzo Padovani',
    curso: 'Engenharia de Computação',
    ra: '20000001',
    color: const [Color(0xFFFF3868), Color(0xFFFFB49A)],
  ),
  ExampleCandidateModel(
    nome: 'João Cavina',
    curso: 'Engenharia de Computação',
    ra: '20000002',
    color: const [Color(0xFF736EFE), Color(0xFF62E4EC)],
  ),
  ExampleCandidateModel(
    nome: 'Vinicius Dezotti',
    curso: 'Engenharia de Computação',
    ra: '20000003',
    color: const [Color(0xFF2F80ED), Color(0xFF56CCF2)],
  ),
  ExampleCandidateModel(
    nome: 'Luis Ciarbello',
    curso: 'Engenharia de Computação',
    ra: '20000004',
    color: const [Color(0xFF0BA4E0), Color(0xFFA9E4BD)],
  ),
  ExampleCandidateModel(
    nome: 'Joao Moraes',
    curso: 'Engenharia de Computação',
    ra: '20000005',
    color: const [Color(0xFF0BA4E0), Color(0xFFA9E4BD)],
  ),
  ExampleCandidateModel(
    nome: 'Jose Manga',
    curso: 'Agronomia',
    ra: '20000006',
    color: const [Color(0xFF0BA4E0), Color(0xFFA9E4BD)],
  ),
];
