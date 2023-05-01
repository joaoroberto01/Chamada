import 'dart:convert';

import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Aula {
  final int id;
  final String nome;
  final String professor;

  Aula({required this.id, required this.nome, required this.professor});
}

class TelaAulas extends StatelessWidget {
  final List<Aula> aulas = [
    Aula(id: 1, nome: "Matemática", professor: "João Silva"),
    Aula(id: 2, nome: "Português", professor: "Maria Souza"),
    Aula(id: 3, nome: "Ciências", professor: "José Santos"),
    Aula(id: 4, nome: "História", professor: "Ana Oliveira"),
    Aula(id: 5, nome: "Geografia", professor: "Pedro Mendes"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aulas"),
      ),
      body: ListView.builder(
        itemCount: aulas.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.school),
              title: Text(aulas[index].nome),
              subtitle: Text("Aula ${aulas[index].id}"),
              onTap: () {
                // Implementar ação ao tocar na aula
                _mostrarModal(context, aulas[index]);
              },
            ),
          );
        },
      ),
    );
  }

void _mostrarModal(BuildContext context, Aula aula) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(aula.nome, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Professor: ${aula.professor}"),
        actions: [
          ElevatedButton(
            child: Text("CONFIRMAR PRESENÇA"),
            onPressed: () async {
              // /chamada/alunos
              /*final response = await http.get(Uri.parse('${Environment.BASE_URL}/chamada/alunos'));
              final data = jsonDecode(response.body);*/
              // Implementar ação ao marcar presença
              _mostrarNotificacao(context, aula);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Fechar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  void _mostrarNotificacao(BuildContext context, Aula aula) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text("Presença solicitada para a aula de ${aula.nome}."),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

}
