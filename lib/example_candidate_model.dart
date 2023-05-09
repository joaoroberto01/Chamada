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

Future<List<ExampleCandidateModel>> fetchCandidates() async {
  final response = await http.get(Uri.parse('http://example.com/candidates'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    return data.map((candidate) => ExampleCandidateModel(
      nome: candidate['nome'],
      curso: candidate['curso'],
      ra: candidate['ra'],
      color: List<Color>.from(candidate['color'].map((c) => Color(c))),
    )).toList();
  } else {
    throw Exception('Failed to load candidates');
  }
}

/*
final List<ExampleCandidateModel> candidates = [
  ExampleCandidateModel(
    name: 'One, 1',
    job: 'Developer',
    city: 'Areado',
    color: const [Color(0xFFFF3868), Color(0xFFFFB49A)],
  ),
  ExampleCandidateModel(
    name: 'Two, 2',
    job: 'Manager',
    city: 'New York',
    color: const [Color(0xFF736EFE), Color(0xFF62E4EC)],
  ),
  ExampleCandidateModel(
    name: 'Three, 3',
    job: 'Engineer',
    city: 'London',
    color: const [Color(0xFF2F80ED), Color(0xFF56CCF2)],
  ),
  ExampleCandidateModel(
    name: 'Four, 4',
    job: 'Designer',
    city: 'Tokyo',
    color: const [Color(0xFF0BA4E0), Color(0xFFA9E4BD)],
  ),
];*/
