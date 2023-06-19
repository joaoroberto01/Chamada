import 'dart:convert';

import 'package:chamada/models/disciplina.dart';
import 'package:chamada/models/professor.dart';
import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListViewProfessor extends StatefulWidget {
  final Disciplina disciplina;

  const ListViewProfessor({
    required this.disciplina,
    Key? key,
  }) : super(key: key);

  @override
  ListViewProfessorState createState() => ListViewProfessorState();
}

class ListViewProfessorState extends State<ListViewProfessor> {
  Professor? selectedProfessor;

  List<Professor> professores = [];

  @override
  void initState() {
    super.initState();
    selectedProfessor = widget.disciplina.professor;
    // colher os dados do server
    _getProfessores();
  }

  Future<void> _getProfessores() async {
    final response = await http.get(Uri.parse('${Environment.BASE_URL}/professores'));
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      professores = List<Professor>.from(data.map((json) => Professor.fromJson(json)));;
    });
  }

  //
  Future<void> _enviarProfessoresSelecionados() async {
    if (selectedProfessor == null) return;

    final url = Uri.parse('${Environment.BASE_URL}/disciplinas/${widget.disciplina.id}/vincular-professor/${selectedProfessor?.id}');
    print(url);
    final response = await http.put(url);
    if (response.statusCode == 200) {
      // sucesso ao enviar alunos selecionados
      _mostrarNotificacao(context);
    } else {
      // falha ao enviar alunos selecionados
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Falha'),
          content: const Text('Ocorreu uma falha ao enviar o professor selecionado.'),
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
        title: const Text('Lista de Professores'),
        centerTitle: true,
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
              child: professores.isEmpty
                  ? const Center(child: Text("Não existem professores nesta disciplina."))
                  : ListView.builder(
                  itemCount: professores.length,
                  itemBuilder: (context, index) {
                  final professor = professores[index];
                  return RadioListTile<Professor>(
                    title: Text(professor.nome),
                    value: professores[index],
                    onChanged: (Professor? value) {
                      setState(() {
                        if (value != null) {
                          selectedProfessor = value;
                          _enviarProfessoresSelecionados();
                        }
                      });
                    },
                    groupValue: selectedProfessor,
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
            Text("Professor atualizado com sucesso."),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
