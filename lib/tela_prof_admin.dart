import 'dart:convert';
import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'aulas_admin.dart';

class Professor {
  final String alunoId;
  final String nome;
  final String ra;
  final String curso;

  Professor({required this.alunoId, required this.nome, required this.ra, required this.curso});

  factory Professor.fromJson(Map<String, dynamic> json) {
    return Professor(
        alunoId: json['id'],
        nome: json['nome'],
        ra: json['ra'],
        curso: json['curso']
    );
  }
}

class ListViewProfessor extends StatefulWidget {
  final Aula aula;

  const ListViewProfessor({
    required this.aula,
    Key? key,
  }) : super(key: key);

  @override
  _ListViewProfessorState createState() => _ListViewProfessorState();
}

class _ListViewProfessorState extends State<ListViewProfessor> {
  Set<Professor> _selectedProfessores = {};

  List<Professor> professores = [];

  List<Professor> getProfessores(List<dynamic> jsonResponse) {
    List<Professor> professores = [];
    for(dynamic data in jsonResponse) {
      Professor professor = Professor.fromJson(data);
      professores.add(professor);
    }
    return professores;
  }

  @override
  void initState() {
    super.initState();
    // colher os dados do server
    _getProfessores();
  }

  Future<void> _getProfessores() async {
    final response = await http.get(Uri.parse('${Environment.BASE_URL}/chamada/matriculas/disciplina/${widget.aula.disciplinaId}'));
    final data = jsonDecode(response.body);
    setState(() {
      professores = getProfessores(data);
    });
  }

  Future<void> _enviarProfessoresSelecionados() async {
    final List<String> selectedIds = _selectedProfessores.map((professor) => professor.alunoId).toList();
    final url = Uri.parse('${Environment.BASE_URL}/chamada/matriculas');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'aulaId': widget.aula.disciplinaId, 'professores': selectedIds}),
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
          content: Text('Ocorreu uma falha ao enviar o professor selecionado.'),
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
        title: Text('Lista de Professores'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _enviarProfessoresSelecionados,
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
                  child: professores.isEmpty
                      ? Center(
                    child: Text("Não existem professores nesta disciplina."),
                  )
                      : ListView.builder(
                    itemCount: professores.length,
                    itemBuilder: (context, index) {
                      final professor = professores[index];
                      return CheckboxListTile(
                        title: Text('${professor.nome} (${professor.curso})'),
                        subtitle: Text('RA: ${professor.ra}'),
                        value: _selectedProfessores.contains(professor),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null && value) {
                              _selectedProfessores.add(professor);
                            } else {
                              _selectedProfessores.remove(professor);
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
