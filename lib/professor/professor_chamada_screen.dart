// import 'dart:convert';
//
// import 'package:chamada/professor_adicionar_alunos_aula_screen.dart';
// import 'package:chamada/shared/environment.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import 'chamada_card.dart';
// import 'example_candidate_model.dart';
// import 'professor_aulas_screen.dart';
//
// import 'package:http/http.dart' as http;
//
// class Example extends StatefulWidget {
//   final Aula aula;
//
//   const Example({
//     required this.aula,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<Example> createState() => _ExamplePageState();
// }
//
// class _ExamplePageState extends State<Example> {
//
//   @override
//   void initState() {
//     super.initState();
//     // colher os dados do server
//     // _getStudentsFromClass();
//   }
//
//   Future<void> _getStudentsFromClass() async {
//     final response = await http.get(Uri.parse('${Environment.BASE_URL}/alunos'));
//     final data = jsonDecode(utf8.decode(response.bodyBytes));
//     setState(() {
//       // _message = data['message'];
//     });
//   }
//
//   final CardSwiperController controller = CardSwiperController();
//
//   final cards = candidates.map((candidate) => ExampleCard(candidate)).toList();
//
//   @override
//   Widget build(BuildContext context) {
//     Aula aula = widget.aula; // acessando a instância de 'Aula'
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back_ios_new)
//         ),
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//         centerTitle: true,
//         actions: [
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 10.0),
//             child: IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ListAlunosAula(aula: aula.disciplinaId)),
//                   );
//                 },
//                 icon: Icon(Icons.settings)),
//           )
//         ],
//         title: Text("${aula.nome}"),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Flexible(
//               child: CardSwiper(
//                 controller: controller,
//                 cardsCount: cards.length,
//                 numberOfCardsDisplayed: cards.length,
//                 isLoop: false,
//                 onSwipe: _onSwipe,
//                 onUndo: _onUndo,
//                 onEnd: () {
//                   print("ACABO");
//                 },
//                 padding: const EdgeInsets.all(24.0),
//                 cardBuilder: (context, index) => cards[index],
//                 isVerticalSwipingEnabled: false,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//
//                   FloatingActionButton(
//                     heroTag: "left",
//                     onPressed: controller.swipeLeft,
//                     backgroundColor: Colors.red,
//                     elevation: 0,
//                     child: const Icon(Icons.close),
//                   ),
//                   FloatingActionButton(
//                     heroTag: "right",
//                     onPressed: controller.swipeRight,
//                     backgroundColor: Colors.green,
//                     elevation: 0,
//                     child: const Icon(Icons.done),
//                   ),
//                   FloatingActionButton(
//                     heroTag: "undo",
//                     onPressed: controller.undo,
//                     elevation: 0,
//                     child: const Icon(Icons.undo),
//                   ),
//
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//   bool _onSwipe(
//       int previousIndex,
//       int? currentIndex,
//       CardSwiperDirection direction,
//       ) {
//     debugPrint(
//
//       'The card $previousIndex was swiped to the ${direction.name} / $direction. Now the card $currentIndex is on top',
//     );
//
//
//     return true;
//   }
//
//   bool _onUndo(
//       int? previousIndex,
//       int currentIndex,
//       CardSwiperDirection direction,
//       ) {
//     debugPrint(
//       'The card $currentIndex was undod from the ${direction.name}',
//     );
//     return true;
//   }

import 'dart:convert';

import 'package:chamada/models/aluno.dart';
import 'package:chamada/models/aula.dart';
import 'package:chamada/professor/professor_adicionar_alunos_aula_screen.dart';
import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;

import 'chamada_card.dart';

class ProfessorChamadaScreen extends StatefulWidget {
  final Aula aula;

  const ProfessorChamadaScreen({
    required this.aula,
    Key? key,
  }) : super(key: key);

  @override
  State<ProfessorChamadaScreen> createState() => _ProfessorChamadaScreenState();
}

class _ProfessorChamadaScreenState extends State<ProfessorChamadaScreen> {
  final CardSwiperController controller = CardSwiperController();

  List<AlunoCard> cards = [];
  List<Aluno> alunos = [];

  void fetchCards() async {
    final response = await http.get(Uri.parse(
        '${Environment.BASE_URL}/frequencias/pendentes/${widget.aula.id}'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      alunos = List<Aluno>.from(jsonData.map((json) => Aluno.fromJson(json)));
    }

    setState(() => {cards = alunos.map((aluno) => AlunoCard(aluno)).toList()});
  }

  @override
  void initState() {
    super.initState();

    fetchCards();
  }

  @override
  Widget build(BuildContext context) {
    Aula aula = widget.aula; // acessando a instância de 'Aula'

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfessorAdicionarAlunosAulaScreen(
                              aula: aula.disciplinaId,
                              alunosPendentes: alunos,
                              onAlunoSelectionChanged: (aluno, selected) {
                                //setState(() => {cards = alunos.map((aluno) => AlunoCard((aluno))).toList()});
                              },
                            )),
                  );
                  setState(() => {cards = alunos.map((aluno) => AlunoCard((aluno))).toList()});
                },
                icon: const Icon(Icons.people_alt)),
          )
        ],
        title: Text(aula.nome),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: cards.isNotEmpty
                    ? CardSwiper(
                        controller: controller,
                        cardsCount: cards.length,
                        numberOfCardsDisplayed: cards.length,
                        isLoop: false,
                        onSwipe: _onSwipe,
                        onUndo: _onUndo,
                        onEnd: () {
                          _finalizarChamada();
                        },
                        padding: const EdgeInsets.all(24.0),
                        cardBuilder: (context, index) => cards[index],
                        allowedSwipeDirection: AllowedSwipeDirection.symmetric(horizontal: true),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(24.0),
                        child:
                            Text("Nenhum aluno solicitou presença nessa aula"),
                      )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: cards.isNotEmpty
                      ? [
                          FloatingActionButton(
                            heroTag: "left",
                            onPressed: controller.swipeLeft,
                            backgroundColor: Colors.red,
                            elevation: 0,
                            child: const Icon(Icons.close),
                          ),
                          FloatingActionButton(
                            heroTag: "undo",
                            onPressed: frequencias.isNotEmpty ? controller.undo : null,
                            elevation: 0,
                            child: const Icon(Icons.undo),
                          ),
                          FloatingActionButton(
                            heroTag: "right",
                            onPressed: controller.swipeRight,
                            backgroundColor: Colors.green,
                            elevation: 0,
                            child: const Icon(Icons.done),
                          ),
                        ]
                      : []),
            )
          ],
        ),
      ),
    );
  }

  List<Frequencia> frequencias = [];

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    Aluno aluno = alunos[previousIndex];

    final frequencia = Frequencia(aluno.id, widget.aula.id, widget.aula.disciplinaId, FrequenciaStatus.PENDENTE);
    if(direction == CardSwiperDirection.left){
      frequencia.status = FrequenciaStatus.AUSENTE;
    }else if(direction == CardSwiperDirection.right){
      frequencia.status = FrequenciaStatus.PRESENTE;
    }

    setState(() {
      frequencias.add(frequencia);
    });

    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    if (frequencias.isEmpty) return false;

    setState(() {
      frequencias.removeLast();
    });

    return true;
  }

  void _finalizarChamada() async {
    List<Map<String, dynamic>> requestBody = frequencias.map((frequencia) => frequencia.toJson()).toList();

    final response = await http.post(
      Uri.parse('${Environment.BASE_URL}/frequencias/finalizar'),
      body: json.encode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      _mostrarNotificacao(context);
    }
  }

  void _mostrarNotificacao(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text("Chamada finalizada com sucesso."),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
enum FrequenciaStatus {
  PENDENTE, PRESENTE, AUSENTE;
}

class Frequencia {
  String alunoId;
  String aulaId;
  String disciplinaId;
  FrequenciaStatus status;

  Frequencia(this.alunoId, this.aulaId, this.disciplinaId, this.status);

  Map<String, dynamic> toJson(){
    return {
      'alunoId': alunoId,
      'aulaId': aulaId,
      'disciplinaId': disciplinaId,
      'status': status.name
    };
  }
}
