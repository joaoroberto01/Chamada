import 'dart:convert';

import 'package:chamada/alunos/porcentagem_circular.dart';
import 'package:chamada/models/aula.dart';
import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../app_state.dart';

class AlunoAulasScreen extends StatefulWidget {
  AlunoAulasScreen({required Key key}) : super(key: key);

  @override
  AlunoAulasScreenState createState() => AlunoAulasScreenState();
}

class AlunoAulasScreenState extends State<AlunoAulasScreen> {
  List<Aula> aulas = [];

  @override
  void initState() {
    super.initState();
    getAulas(); // Obter as aulas do servidor ao iniciar a tela
  }

  Future<void> getAulas() async {
    final appState = Provider.of<AppState>(context, listen: false);
    String? userId = appState.userId;
    print(userId);
    final response = await http.get(Uri.parse(
        '${Environment.BASE_URL}/aulas/aluno/$userId')); // Substitua pela URL correta do seu servidor

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        aulas = List<Aula>.from(data.map((x) => Aula.fromJson(x)));
      });
    } else {
      print('Erro na requisição: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        aulas.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: aulas.length,
                  itemBuilder: (BuildContext context, int index) {
                    final aula = aulas[index];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          enabled: !aula.chamadaRealizada,
                          leading: PorcentagemCircular(
                              percentual: aula.porcentagem?.toDouble() ?? 0),
                          title: Text(aula.nome),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Professor: ${aula.professor}"),
                              Text(
                                  "${aula.diaDaSemana.value}, ${aula.horario}"),
                            ],
                          ),
                          onTap: () {
                            _mostrarModal(context, aula);
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            : const Center(child: Text("Nenhuma aula para hoje"))
      ],
    ));
  }

  void _mostrarModal(BuildContext context, Aula aula) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(aula.nome,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                aula.diaDaSemana.value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Horário: ${aula.horario}'),
            ],
          ),
          actions: [
            OutlinedButton(
              child: const Text("Solicitar Presença"),
              onPressed: () async {
                final appState = Provider.of<AppState>(context, listen: false);
                String? userId = appState.userId;
                String aulaId = aula.id;

                var requestBody = {
                  'alunoId': userId,
                  'aulaId': aulaId,
                };

                var url = Uri.parse('${Environment.BASE_URL}/frequencias');
                var response = await http.post(
                  url,
                  body: json.encode(requestBody),
                  headers: {'Content-Type': 'application/json'},
                );

                if (response.statusCode == 200) {
                  _mostrarNotificacao(context);
                }

                setState(() {});
                Navigator.of(context).pop();
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
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            const Text("Presença solicitada com sucesso."),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
