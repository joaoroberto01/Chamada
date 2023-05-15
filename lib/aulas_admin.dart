import 'dart:convert';

import 'package:chamada/shared/environment.dart';
import 'package:chamada/tela_admin.dart';
import 'package:chamada/tela_prof_admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


enum DiaDaSemana { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY }

class Aula {
  final String disciplinaId;
  final String nome;

  Aula({required this.disciplinaId, required this.nome});

  factory Aula.fromJson(Map<String, dynamic> json) {
    return Aula(
        disciplinaId: json['id'],
        nome: json['nome'],
    );
  }
}

class AulasAdmin extends StatefulWidget {
  @override
  _AulasAdminState createState() => _AulasAdminState();
}

class _AulasAdminState extends State<AulasAdmin> {
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
    _getClasses();
  }

  Future<void> _getClasses() async {
    final response = await http.get(Uri.parse('${Environment.BASE_URL}/chamada/disciplinas'));
    final data = jsonDecode(response.body);
    setState(() {
      aulas = getAulas(data);
    });
  }


  DiaDaSemana? _diaSelecionado;

  List<Aula> get _aulasFiltradas {
    return aulas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disciplinas"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child:
              ListView.builder(
                itemCount: _aulasFiltradas.length,
                itemBuilder: (context, index) {
                  final aula = _aulasFiltradas[index];
                  return GestureDetector(
                    onTap: () {
                      _mostrarModal(context, aulas[index]);
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ListViewAlunos(aula: aula)));*/
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
          actions: [
            ElevatedButton(
              child: Text("Gerenciar alunos"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListViewAlunos(aula: aula)),
                );
              },
            ),
            ElevatedButton(
              child: Text("Gerenciar professores"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListViewProfessor(aula: aula)),
                );
              },
            ),
          ],
        );
      },
    );
  }

}
