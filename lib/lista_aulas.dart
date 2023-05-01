import 'dart:convert';

import 'package:chamada/lista_alunos.dart';
import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


enum DiaDaSemana { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY }

class Aula {
  final int id;
  final String nome;
  final DiaDaSemana diaDaSemana;

  const Aula({required this.id, required this.nome, required this.diaDaSemana});
}

class AulasScreen extends StatefulWidget {
  @override
  _AulasScreenState createState() => _AulasScreenState();
}

class _AulasScreenState extends State<AulasScreen> {
  @override
  void initState() {
    super.initState();
    // colher os dados do server
    // _getTeacherClasses();
  }

  Future<void> _getTeacherClasses() async {
    final response = await http.get(Uri.parse('${Environment.BASE_URL}/chamada/alunos'));
    final data = jsonDecode(response.body);
    setState(() {
      // _message = data['message'];
    });
  }

  // ATENÇÃO
  // ATENÇÃO
  // ATENÇÃO
  // ATENÇÃO
  // O Widget abaixoé temporário pois está funcionando com DADOS ESTÁTICOS.
  // assim que as requisições forem feitas, os dados serão DINÂMICOS.

  final List<Aula> aulas = [
    Aula(id: 1, nome: "Matemática", diaDaSemana: DiaDaSemana.MONDAY),
    Aula(id: 2, nome: "História", diaDaSemana: DiaDaSemana.TUESDAY),
    Aula(id: 3, nome: "Biologia", diaDaSemana: DiaDaSemana.WEDNESDAY),
    Aula(id: 4, nome: "Geografia", diaDaSemana: DiaDaSemana.THURSDAY),
    Aula(id: 5, nome: "Português", diaDaSemana: DiaDaSemana.FRIDAY),
  ];

  DiaDaSemana? _diaSelecionado;

  List<Aula> get _aulasFiltradas {
    if (_diaSelecionado == null) {
      return aulas;
    } else {
      return aulas.where((aula) => aula.diaDaSemana == _diaSelecionado).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aulas da semana"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<DiaDaSemana>(
              value: _diaSelecionado,
              onChanged: (value) {
                setState(() {
                  _diaSelecionado = value;
                });
              },
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text("Mostrar todas as aulas"),
                ),
                ...DiaDaSemana.values.map((dia) {
                  return DropdownMenuItem(
                    value: dia,
                    child: Text(_getNomeDiaDaSemana(dia)),
                  );
                }).toList(),
              ],
            ),
          ),
          Expanded(
              child: _aulasFiltradas.isEmpty
                ? Center(
                    child: Text("Você não possui aulas neste dia."),
              )
                : ListView.builder(
                    itemCount: _aulasFiltradas.length,
                    itemBuilder: (context, index) {
                      final aula = _aulasFiltradas[index];
                      return GestureDetector(
                        onTap: () {
                          _mostrarModal(context, aula);
                        },
                        child: Card(
                          child: ListTile(
                            leading: Icon(Icons.account_balance),
                            title: Text(aula.nome),
                          ),
                        ),
                      );
                    },
              )
          ),
        ],
      ),
    );
  }

  void _mostrarModal(BuildContext context, Aula aula) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(aula.nome),
          content: Text("Testando"),
          actions: [
            ElevatedButton(
              child: Text("Iniciar chamada"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Example(aula: aula)),
                );
              },
            ),
            /*TextButton(
              child: Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),*/
          ],
        );
      },
    );
  }

  String _getNomeDiaDaSemana(DiaDaSemana dia) {
    switch (dia) {
      case DiaDaSemana.MONDAY:
        return "Segunda-feira";
      case DiaDaSemana.TUESDAY:
        return "Terça-feira";
      case DiaDaSemana.WEDNESDAY:
        return "Quarta-feira";
      case DiaDaSemana.THURSDAY:
        return "Quinta-feira";
      case DiaDaSemana.FRIDAY:
        return "Sexta-feira";
      default:
        return "";
    }
  }
}
