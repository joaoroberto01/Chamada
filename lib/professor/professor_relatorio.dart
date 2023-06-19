import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../shared/environment.dart';

class RelatorioProfessor extends StatefulWidget {
  @override
  _RelatorioProfessorState createState() => _RelatorioProfessorState();

  final String disciplinaId;
  RelatorioProfessor({required this.disciplinaId});
}

class _RelatorioProfessorState extends State<RelatorioProfessor> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    getReport();
  }

  Future<void> getReport() async {
    final response = await http.get(Uri.parse('${Environment.BASE_URL}/frequencias/${widget.disciplinaId}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      // final data = jsonDecode(utf8.decode(response.bodyBytes));

      List<Student> fetchedStudents = List<Student>.from(data.map((student) {
        return Student(
          nome: student['nome'],
          ra: student['ra'],
          curso: student['curso'],
          aulasPresentes: student['aulasPresentes'],
          aulasTotais: student['aulasTotais'],
        );
      }));

      setState(() {
        students = fetchedStudents;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequência de Alunos'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            child: ListTile(
              title: Text(student.nome),
              subtitle: Text('RA: ${student.ra}'),
              trailing: Text('Frequência: ${student.aulasPresentes} / ${student.aulasTotais}'),
            ),
          );
        },
      ),
    );
  }
}

class Student {
  final String nome;
  final String ra;
  final String curso;
  final int aulasPresentes;
  final int aulasTotais;

  Student({
    required this.nome,
    required this.ra,
    required this.curso,
    required this.aulasPresentes,
    required this.aulasTotais,
  });
}
