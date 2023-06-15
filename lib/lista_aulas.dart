import 'dart:convert';

import 'package:chamada/lista_alunos.dart';
import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'app_state.dart';


enum DiaDaSemana { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY }

class Aula {
  final String id;
  final String disciplinaId;
  final String nome;
  final String diaDaSemana;
  final String horario;

  Aula({required this.id, required this.disciplinaId, required this.nome, required this.diaDaSemana, required this.horario});

  factory Aula.fromJson(Map<String, dynamic> json) {
    return Aula(
      id: json['id'],
      disciplinaId: json['disciplinaId'],
      nome: json['disciplina']['nome'],
      diaDaSemana: json['diaDaSemana'],
      horario: json['horario']
    );
  }
}

class AulasScreen extends StatefulWidget {
  @override
  _AulasScreenState createState() => _AulasScreenState();
}

class _AulasScreenState extends State<AulasScreen> {
  List<Aula> aulas = [];

  List<Aula> getAulas(List<dynamic> jsonResponse) {
    List<Aula> aulas = [];
    for(dynamic data in jsonResponse) {
      Aula aula = Aula.fromJson(data);
      aulas.add(aula);
    }
    return aulas;
  }

  @override
  void initState() {
    super.initState();
    // colher os dados do server
    _getTeacherClasses();
  }

  Future<void> _getTeacherClasses() async {
    final appState = Provider.of<AppState>(context, listen: false);
    String? userId = appState.userId;

    final response = await http.get(Uri.parse('${Environment.BASE_URL}/chamada/aulas/professor/$userId'));
    final data = jsonDecode(response.body);
    setState(() {
      aulas = getAulas(data);
    });
  }


  DiaDaSemana? _diaSelecionado;

  List<Aula> get _aulasFiltradas {
    if (_diaSelecionado == null) {
      return aulas;
    } else {
      return aulas.where((aula) => aula.diaDaSemana == _diaSelecionado.toString().split('.')[1]).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text("Aulas da semana"),
        centerTitle: true,
      ),*/
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
                            subtitle: Text(aula.horario),
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
          content: Text('Horário: ${aula.horario}'),
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
