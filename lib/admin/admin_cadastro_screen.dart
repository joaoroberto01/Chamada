import 'dart:convert';

import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminCadastroScreen extends StatelessWidget {
  const AdminCadastroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _showCadastroModal(context, 'Aluno');
              },
              child: const Text('Cadastrar Aluno'),
            ),
            ElevatedButton(
              onPressed: () {
                _showCadastroModal(context, 'Professor');
              },
              child: const Text('Cadastrar Professor'),
            ),
          ],
        ),
      ),
    );
  }

  /*void _showCadastroModal(BuildContext context, String tipo) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Cadastro de $tipo',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Login',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Simula um cadastro bem-sucedido
                      Future.delayed(Duration(seconds: 2), () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Cadastro realizado com sucesso!',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        Navigator.pop(context); // Fecha o modal
                      });
                    },
                    child: const Text('Cadastrar'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }*/

  void _showCadastroModal(BuildContext context, String tipo) {
    String? url;
    if (tipo == 'Professor') {
      url = '${Environment.BASE_URL}/professores';
    } else if (tipo == 'Aluno') {
      url = '${Environment.BASE_URL}/alunos';
    }

    TextEditingController nomeController = TextEditingController();
    TextEditingController raController = TextEditingController();
    TextEditingController loginController = TextEditingController();
    TextEditingController senhaController = TextEditingController();
    TextEditingController cursoController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cadastro de $tipo',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                        ),
                      ),
                      TextField(
                        controller: raController,
                        decoration: const InputDecoration(
                          labelText: 'RA (Registro Academico)',
                        ),
                      ),
                      if (tipo == 'Aluno')
                        TextField(
                          controller: cursoController,
                          decoration: const InputDecoration(
                            labelText: 'Curso',
                          ),
                        ),
                      TextField(
                        controller: loginController,
                        decoration: const InputDecoration(
                          labelText: 'Login',
                        ),
                      ),
                      TextField(
                        controller: senhaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          String nome = nomeController.text; // Obtenha o valor do campo de texto do nome
                          String ra = raController.text;
                          String curso = cursoController.text;
                          String login = loginController.text; // Obtenha o valor do campo de texto do login
                          String senha = senhaController.text; // Obtenha o valor do campo de texto da senha

                          // Construa o corpo da solicitação POST com base no tipo de cadastro
                          var requestBody = {
                            'nome': nome,
                            'ra': ra,
                            'curso': curso,
                            'login': login,
                            'senha': senha,
                          };

                          // Enviar a solicitação POST
                          var response = await http.post(
                            Uri.parse(url!),
                            body: json.encode(requestBody),
                            headers: {'Content-Type': 'application/json'},
                          );

                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: const [
                                    Icon(Icons.check_circle,
                                        color: Colors.green),
                                    SizedBox(width: 8),
                                    Text("Cadastro realizado com sucesso."),
                                  ],
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                            Navigator.pop(context); // Fecha o modal
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Row(
                                  children: const [
                                    Icon(
                                      Icons.error,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Falha ao cadastrar!',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: const Text('Cadastrar'),
                      ),
                    ],
                  ),
                )));
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdminCadastroScreen(),
  ));
}
