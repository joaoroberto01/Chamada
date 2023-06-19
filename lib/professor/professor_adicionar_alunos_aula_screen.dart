import 'dart:convert';

import 'package:chamada/models/aluno.dart';
import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfessorAdicionarAlunosAulaScreen extends StatefulWidget {
  final String aula;
  final List<Aluno> alunosPendentes;
  final Function(Aluno aluno, bool value) onAlunoSelectionChanged;

  const ProfessorAdicionarAlunosAulaScreen({
    required this.aula,
    required this.alunosPendentes,
    required this.onAlunoSelectionChanged,
    Key? key,
  }) : super(key: key);

  @override
  _ProfessorAdicionarAlunosAulaScreenState createState() =>
      _ProfessorAdicionarAlunosAulaScreenState();
}

class _ProfessorAdicionarAlunosAulaScreenState
    extends State<ProfessorAdicionarAlunosAulaScreen> {
  List<Aluno> _alunos = [];

  @override
  void initState() {
    super.initState();
    _getStudents();
  }

  Future<void> _getStudents() async {
    final response = await http.get(
        Uri.parse('${Environment.BASE_URL}/alunos/disciplina/${widget.aula}'));
    final data = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      _alunos = List<Aluno>.from(data.map((json) => Aluno.fromJson(json)));
      if(widget.alunosPendentes.isEmpty) return;

      _alunos = _alunos
          .where((aluno) {
        return !widget.alunosPendentes.contains(aluno);
      })
          .toList();
      print('students fetched');
    });
  }

  Future<void> _enviarAlunosSelecionados() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Alunos'),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.check),
          //   onPressed: _enviarAlunosSelecionados,
          // ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _alunos.isEmpty
                    ? const Center(
                        child: Text("Não existem alunos nesta disciplina."),
                      )
                    : ListView.builder(
                        itemCount: _alunos.length,
                        itemBuilder: (context, index) {
                          final aluno = _alunos[index];
                          return CheckboxListTile(
                            title: Text(aluno.nome),
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('RA: ${aluno.ra}'),
                                  Text('Curso: ${aluno.curso}'),
                                ],
                              ),
                            ),
                            value: widget.alunosPendentes.contains(aluno),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == null) return;

                                if (value) {
                                  widget.alunosPendentes.add(aluno);
                                  print("alunosPendentes (ou alunos) -> added: length = ${widget.alunosPendentes.length}");
                                } else {
                                  widget.alunosPendentes.remove(aluno);
                                }

                                widget.onAlunoSelectionChanged(aluno, value);
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
