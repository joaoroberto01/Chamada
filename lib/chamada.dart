import 'package:flutter/material.dart';
import 'lista_aulas.dart';

class ChamadaScreen extends StatelessWidget {
  final Aula aula;

  const ChamadaScreen({required this.aula});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chamada - ${aula.nome}"),
      ),
      body: Center(
        child: Text("Esta é a tela de chamada para a aula de ${aula.nome}"),
      ),
    );
  }
}
