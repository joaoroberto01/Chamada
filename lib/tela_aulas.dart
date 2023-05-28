import 'dart:convert';
import 'package:chamada/porcentagem_circular.dart';
import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Aula {
  final int id;
  final String nome;
  final String professor;
  double porcentagem;

  Aula({required this.id, required this.nome, required this.professor, this.porcentagem = 0.0});
}

class TelaAulas extends StatefulWidget {
  @override
  _TelaAulasState createState() => _TelaAulasState();
}

class _TelaAulasState extends State<TelaAulas> {
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
      /*appBar: AppBar(
        title: Text("Aulas"),
      ),*/
      body: ListView.builder(
        itemCount: aulas.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: PorcentagemCircular(percentual: aulas[index].porcentagem.toDouble()),
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
                // Implementar ação ao marcar presença
                _mostrarNotificacao(context, aula);
                setState(() {
                  aula.porcentagem += 20.0;
                });
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