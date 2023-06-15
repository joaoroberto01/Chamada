// import 'dart:convert';
//
// import 'package:chamada/shared/environment.dart';
// import 'package:chamada/tela_admin.dart';
// import 'package:chamada/tela_prof_admin.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
//
// enum DiaDaSemana { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY }
//
// class Aula {
//   final String disciplinaId;
//   final String nome;
//
//   Aula({required this.disciplinaId, required this.nome});
//
//   factory Aula.fromJson(Map<String, dynamic> json) {
//     return Aula(
//         disciplinaId: json['id'],
//         nome: json['nome'],
//     );
//   }
// }
//
// class AulasAdmin extends StatefulWidget {
//   @override
//   _AulasAdminState createState() => _AulasAdminState();
// }
//
// class _AulasAdminState extends State<AulasAdmin> {
//   List<Aula> aulas = [];
//
//   List<Aula> getAulas(List<dynamic> jsonResponse) {
//     List<Aula> aulas = [];
//     for(dynamic data in jsonResponse) {
//       Aula aula = Aula.fromJson(data);
//       aulas.add(aula);
//     }
//     return aulas;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // colher os dados do server
//     _getClasses();
//   }
//
//   Future<void> _getClasses() async {
//     final response = await http.get(Uri.parse('${Environment.BASE_URL}/chamada/disciplinas'));
//     final data = jsonDecode(response.body);
//     setState(() {
//       aulas = getAulas(data);
//     });
//   }
//
//
//   DiaDaSemana? _diaSelecionado;
//
//   List<Aula> get _aulasFiltradas {
//     return aulas;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       /*appBar: AppBar(
//         title: Text("Disciplinas"),
//         centerTitle: true,
//       ),*/
//       body: Column(
//         children: [
//           Expanded(
//               child:
//               ListView.builder(
//                 itemCount: _aulasFiltradas.length,
//                 itemBuilder: (context, index) {
//                   final aula = _aulasFiltradas[index];
//                   return GestureDetector(
//                     onTap: () {
//                       _mostrarModal(context, aulas[index]);
//                       /*Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => ListViewAlunos(aula: aula)));*/
//                     },
//                     child: Card(
//                       child: ListTile(
//                         leading: Icon(Icons.account_balance),
//                         title: Text(aula.nome),
//                       ),
//                     ),
//                   );
//                 },
//               )
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _mostrarModal(BuildContext context, Aula aula) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(aula.nome),
//           actions: [
//             ElevatedButton(
//               child: Text("Gerenciar alunos"),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ListViewAlunos(aula: aula)),
//                 );
//               },
//             ),
//             ElevatedButton(
//               child: Text("Gerenciar professores"),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ListViewProfessor(aula: aula)),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
// }


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
    for (dynamic data in jsonResponse) {
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
    final response =
    await http.get(Uri.parse('${Environment.BASE_URL}/chamada/disciplinas'));
    final data = jsonDecode(response.body);
    setState(() {
      aulas = getAulas(data);
    });
  }

  DiaDaSemana? _diaSelecionado;

  List<Aula> get _aulasFiltradas {
    return aulas;
  }

  TextEditingController _novaDisciplinaController = TextEditingController();

  void _adicionarDisciplina() async {
    String nomeDisciplina = _novaDisciplinaController.text;

    // Criar um mapa com os dados da disciplina
    Map<String, dynamic> disciplinaData = {
      'nome': nomeDisciplina,
      // Adicione aqui outros campos necessários para a disciplina
    };

    // Converter o mapa para JSON
    String disciplinaJson = jsonEncode(disciplinaData);

    try {
      // Enviar a solicitação POST para o servidor
      final response = await http.post(
        Uri.parse('${Environment.BASE_URL}/chamada/disciplinas'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: disciplinaJson,
      );

      if (response.statusCode == 200) {
        print('disciplina criada');
      } else {
        print('erro ao criar disciplina');
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      // Adicionar a nova disciplina à lista de aulas
      Aula novaDisciplina = Aula(disciplinaId: 'id', nome: nomeDisciplina);
      aulas.add(novaDisciplina);
    });

    // Fechar o modal
    Navigator.of(context).pop();
  }


  void _removerDisciplina(int index) async {
    final disciplinaRemovida = aulas[index];
    print(disciplinaRemovida.disciplinaId);

    try {
      // Enviar a solicitação DELETE para o servidor
      final response = await http.delete(
        Uri.parse('${Environment.BASE_URL}/chamada/disciplinas/${disciplinaRemovida.disciplinaId}'),
      );

      if (response.statusCode == 200) {
        print('disciplina removida');
      } else {
        print('erro ao remover disciplina');
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      // Remover a disciplina da lista localmente
      aulas.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _aulasFiltradas.length,
              itemBuilder: (context, index) {
                final aula = _aulasFiltradas[index];
                return GestureDetector(
                  onTap: () {
                    _mostrarModal(context, aula);
                  },
                  child: Dismissible(
                    key: Key(aula.disciplinaId),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      _removerDisciplina(index);
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.account_balance),
                        title: Text(aula.nome),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Adicionar Disciplina"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _novaDisciplinaController,
                            decoration: InputDecoration(
                              labelText: "Nome da Disciplina",
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          child: Text("Adicionar"),
                          onPressed: _adicionarDisciplina,
                        ),
                      ],
                    );
                  },
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8.0),
                  Text("Adicionar Disciplina"),
                ],
              ),
            ),
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
                  MaterialPageRoute(
                    builder: (context) => ListViewAlunos(aula: aula),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text("Gerenciar professores"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListViewProfessor(aula: aula),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}



