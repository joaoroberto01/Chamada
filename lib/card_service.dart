import 'example_candidate_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CardService {
  List<ExampleCandidateModel> cards = [];

  Future<List<ExampleCandidateModel>> fetchCards() async {
    final response = await http.get(Uri.parse('http://exemplo.com/candidatos'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return List<ExampleCandidateModel>.from(jsonData.map((json) =>
          ExampleCandidateModel(
            nome: json['nome'],
            curso: json['curso'],
            ra: json['ra'],
            color: List<Color>.from(json['color'].map((c) => Color(c))),
          )));
    } else {
      throw Exception('Falha ao carregar os dados dos candidatos.');
    }
  }

  List<ExampleCandidateModel> getCards() {
    return cards;
  }
}
