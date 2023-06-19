import 'dart:convert';

import 'package:chamada/models/aula.dart';
import 'package:chamada/models/dia_da_semana.dart';
import 'package:chamada/professor/professor_chamada_screen.dart';
import 'package:chamada/professor/professor_relatorio.dart';
import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../app_state.dart';

class ProfessorAulasScreen extends StatefulWidget {
  @override
  _ProfessorAulasScreenState createState() => _ProfessorAulasScreenState();
}

class _ProfessorAulasScreenState extends State<ProfessorAulasScreen> {
  List<Aula> aulas = [];

  @override
  void initState() {
    super.initState();
    // colher os dados do server
    _getTeacherClasses();
  }

  Future<void> _getTeacherClasses() async {
    final appState = Provider.of<AppState>(context, listen: false);
    String? userId = appState.userId;

    final response = await http.get(Uri.parse('${Environment.BASE_URL}/aulas/professor/$userId'));
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      aulas = List<Aula>.from(data.map((json) => Aula.fromJson(json)));
    });
  }

  DiaDaSemana? _diaSelecionado;

  List<Aula> get _aulasFiltradas {
    if (_diaSelecionado == null) {
      return aulas;
    }
    return aulas.where((aula) => aula.diaDaSemana == _diaSelecionado).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    const DropdownMenuItem(
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
              IconButton(onPressed: () {_getTeacherClasses();}, icon: const Icon(Icons.refresh))
            ],
          ),
          Expanded(
              child: _aulasFiltradas.isEmpty
                ? const Center(
                    child: Text("Você não possui aulas neste dia."),
              )
                : ListView.builder(
                    itemCount: _aulasFiltradas.length,
                    itemBuilder: (context, index) {
                      final aula = _aulasFiltradas[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.account_balance),
                          title: Text(aula.nome),
                          subtitle: Text("${aula.diaDaSemana.value} - ${aula.horario}"),
                          onTap: () {
                            _mostrarModal(context, aula);
                          },
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(aula.diaDaSemana.value, style: const TextStyle(fontWeight: FontWeight.bold),),
              Text('Horário: ${aula.horario}'),
            ],
          ),
          actions: [
            OutlinedButton(
              child: const Text("Iniciar chamada"),
              onPressed: !aula.chamadaRealizada ? () async {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfessorChamadaScreen(aula: aula)),
                );
                _getTeacherClasses();
              } : null,
            ),
            OutlinedButton(
              child: const Text("Relatório de Presença"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                _abrirTelaRelatorioPresenca(aula.disciplinaId);
              },
            ),
          ],
        );
      },
    );
  }

  void _abrirTelaRelatorioPresenca(String disciplinaId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RelatorioProfessor(disciplinaId: disciplinaId)),
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
