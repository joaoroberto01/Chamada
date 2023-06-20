import 'dart:convert';

import 'package:chamada/models/aluno.dart';
import 'package:chamada/models/disciplina.dart';
import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListViewAlunos extends StatefulWidget {
  final Disciplina disciplina;

  const ListViewAlunos({
    required this.disciplina,
    Key? key,
  }) : super(key: key);

  @override
  ListViewAlunosState createState() => ListViewAlunosState();
}

class ListViewAlunosState extends State<ListViewAlunos> {
  List<Aluno> _selectedAlunos = [];

  List<Aluno> alunos = [];

  @override
  void initState() {
    super.initState();
    // colher os dados do server
    _getStudents();
    _getSelectedStudents();
  }

  Future<void> _getStudents() async {
    final response = await http.get(Uri.parse('${Environment.BASE_URL}/alunos'));
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      alunos = List<Aluno>.from(data.map((json) => Aluno.fromJson(json)));
    });
  }

  Future<void> _getSelectedStudents() async {
    final response = await http.get(Uri.parse('${Environment.BASE_URL}/matriculas/${widget.disciplina.id}'));
    final data = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      _selectedAlunos = List<Aluno>.from(data.map((json) => Aluno.fromJson(json)));
    });
  }

  Future<void> _enviarAlunosSelecionados() async {
    final List<String> selectedIds = _selectedAlunos.map((aluno) => aluno.id).toList();
    final url = Uri.parse('${Environment.BASE_URL}/matriculas');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'disciplinaId': widget.disciplina.id, 'alunos': selectedIds}),
    );
    if (response.statusCode == 200) {
      // sucesso ao enviar alunos selecionados
      _mostrarNotificacao(context);
      Navigator.pop(context);
    } else {
      // falha ao enviar alunos selecionados
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Falha'),
          content: const Text('Ocorreu uma falha ao enviar os alunos selecionados.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
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
        title: const Text('Lista de Alunos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _enviarAlunosSelecionados,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.disciplina.nome,
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
            Expanded(
              child: alunos.isEmpty
                  ? const Center(child: Text("Não existem alunos nesta disciplina."))
                : ListView.builder(
                itemCount: alunos.length,
                itemBuilder: (context, index) {
                  final aluno = alunos[index];
                  return CheckboxListTile(
                    title: Text(aluno.nome),
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
        ),
      ),

    );
  }

  void _mostrarNotificacao(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text("Alunos matriculados com sucesso."),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
