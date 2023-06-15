import 'dart:convert';
import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'aulas_admin.dart';

class Aluno {
  final String alunoId;
  final String nome;
  final String? ra;
  final String? curso;

  Aluno({required this.alunoId, required this.nome, required this.ra, required this.curso});

  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      alunoId: json['id'],
      nome: json['nome'],
      ra: json['ra'],
      curso: json['curso']
    );
  }
}

class ListViewAlunos extends StatefulWidget {
  final Aula aula;

  const ListViewAlunos({
    required this.aula,
    Key? key,
  }) : super(key: key);

  @override
  _ListViewAlunosState createState() => _ListViewAlunosState();
}

class _ListViewAlunosState extends State<ListViewAlunos> {
  Set<Aluno> _selectedAlunos = {};

  List<Aluno> alunos = [];

  List<Aluno> getAlunos(List<dynamic> jsonResponse) {
    List<Aluno> alunos = [];
    for(dynamic data in jsonResponse) {
      Aluno aluno = Aluno.fromJson(data);
      alunos.add(aluno);
    }
    return alunos;
  }

  @override
  void initState() {
    super.initState();
    // colher os dados do server
    _getStudents();
  }

  Future<void> _getStudents() async {
    // final response = await http.get(Uri.parse('${Environment.BASE_URL}/chamada/matriculas/disciplina/${widget.aula.disciplinaId}'));
    final response = await http.get(Uri.parse('${Environment.BASE_URL}/chamada/alunos'));
    final data = jsonDecode(response.body);
    setState(() {
      alunos = getAlunos(data);
    });
  }

  Future<void> _enviarAlunosSelecionados() async {
    final List<String> selectedIds = _selectedAlunos.map((aluno) => aluno.alunoId).toList();
    final url = Uri.parse('${Environment.BASE_URL}/chamada/matriculas');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'disciplinaId': widget.aula.disciplinaId, 'alunos': selectedIds}),
    );
    if (response.statusCode == 200) {
      // sucesso ao enviar alunos selecionados
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sucesso'),
          content: Text('Disciplina atualizada com sucesso!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // falha ao enviar alunos selecionados
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Falha'),
          content: Text('Ocorreu uma falha ao enviar os alunos selecionados.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Alunos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _enviarAlunosSelecionados,
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  widget.aula.nome,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Expanded(
                child: alunos.isEmpty
                    ? Center(
                  child: Text("Não existem alunos nesta disciplina."),
                )
                  : ListView.builder(
                  itemCount: alunos.length,
                  itemBuilder: (context, index) {
                    final aluno = alunos[index];
                    return CheckboxListTile(
                      title: Text('${aluno.nome}'),
                      subtitle: Text('RA: ${aluno.ra}'),
                      value: _selectedAlunos.contains(aluno),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null && value) {
                            _selectedAlunos.add(aluno);
                          } else {
                            _selectedAlunos.remove(aluno);
                          }
                        });
                      },
                    );
                  },
                ),
              )

            ],
          )
        ),
      ),

    );
  }
}
