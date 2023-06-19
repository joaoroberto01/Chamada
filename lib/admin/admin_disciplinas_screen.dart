import 'dart:convert';

import 'package:chamada/admin/admin_lista_alunos_screen.dart';
import 'package:chamada/admin/admin_lista_profs_screen.dart';
import 'package:chamada/models/disciplina.dart';
import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminDisciplinasScreen extends StatefulWidget {

  AdminDisciplinasScreen({super.key});

  @override
  AdminDisciplinasScreenState createState() => AdminDisciplinasScreenState();
}

class AdminDisciplinasScreenState extends State<AdminDisciplinasScreen> {
  List<Disciplina> disciplinas = [];

  @override
  void initState() {
    super.initState();
    // colher os dados do server
    getClasses();
  }

  Future<void> getClasses() async {
    final response =
    await http.get(Uri.parse('${Environment.BASE_URL}/disciplinas'));
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      disciplinas = List<Disciplina>.from(data.map((x) => Disciplina.fromJson(x)));
    });
  }

  final TextEditingController _novaDisciplinaController = TextEditingController();

  void _adicionarDisciplina() async {
    String nomeDisciplina = _novaDisciplinaController.text;

    Map<String, dynamic> disciplinaData = {
      'nome': nomeDisciplina,
    };

    try {
      final response = await http.post(
        Uri.parse('${Environment.BASE_URL}/disciplinas'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(disciplinaData),
      );

      if (response.statusCode == 200) {
        print('disciplina criada');
      } else {
        print('erro ao criar disciplina');
        return;
      }
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      Disciplina novaDisciplina = Disciplina.fromJson(data);
      setState(() {
        disciplinas.add(novaDisciplina);
      });
      _mostrarNotificacao(context);
    } catch (e) {
      print(e);
    }

    // Fechar o modal
    Navigator.of(context).pop();
  }


  void _removerDisciplina(int index) async {
    final disciplinaRemovida = disciplinas[index];
    print(disciplinaRemovida.id);

    try {
      // Enviar a solicitação DELETE para o servidor
      final response = await http.delete(
        Uri.parse('${Environment.BASE_URL}/disciplinas/${disciplinaRemovida.id}'),
      );

      if (response.statusCode == 200) {
        print('disciplina removida');
      } else {
        print('erro ao remover disciplina');
        return;
      }
      setState(() {
        // Remover a disciplina da lista localmente
        disciplinas.removeAt(index);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: disciplinas.length,
              itemBuilder: (context, index) {
                final disciplina = disciplinas[index];
                return GestureDetector(
                  onTap: () {
                    _mostrarModal(context, disciplina);
                  },
                  child: Dismissible(
                    key: Key(disciplina.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      _removerDisciplina(index);
                    },
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.account_balance),
                        title: Text(disciplina.nome),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Adicionar Disciplina"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _novaDisciplinaController,
                            decoration: const InputDecoration(
                              labelText: "Nome da Disciplina",
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        OutlinedButton(
                          onPressed: _adicionarDisciplina,
                          child: const Text("Adicionar"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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

  void _mostrarModal(BuildContext context, Disciplina disciplina) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(disciplina.nome),
          actions: [
            OutlinedButton(
              child: const Text("Gerenciar alunos"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListViewAlunos(disciplina: disciplina),
                  ),
                );
              },
            ),
            OutlinedButton(
              child: const Text("Gerenciar professor"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListViewProfessor(disciplina: disciplina),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarNotificacao(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text("Disciplina adicionada com sucesso."),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}



