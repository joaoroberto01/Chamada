// import 'dart:convert';
//
// import 'package:chamada/alunos_aula.dart';
// import 'package:chamada/shared/environment.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import 'example_card.dart';
// import 'example_candidate_model.dart';
// import 'lista_aulas.dart';
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
//     final response = await http.get(Uri.parse('${Environment.BASE_URL}/chamada/alunos'));
//     final data = jsonDecode(response.body);
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

import 'package:chamada/alunos_aula.dart';
import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'example_card.dart';
import 'example_candidate_model.dart';
import 'lista_aulas.dart';

import 'package:http/http.dart' as http;

class Example extends StatefulWidget {
  final Aula aula;

  const Example({
    required this.aula,
    Key? key,
  }) : super(key: key);

  @override
  State<Example> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<Example> {
  final CardSwiperController controller = CardSwiperController();

  final cards = candidates.map((candidate) => ExampleCard(candidate)).toList();

  @override
  Widget build(BuildContext context) {
    Aula aula = widget.aula; // acessando a instância de 'Aula'

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListAlunosAula(aula: aula.disciplinaId)),
                  );
                },
                icon: Icon(Icons.settings)),
          )
        ],
        title: Text("${aula.nome}"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: CardSwiper(
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
                isVerticalSwipingEnabled: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: "left",
                    onPressed: controller.swipeLeft,
                    backgroundColor: Colors.red,
                    elevation: 0,
                    child: const Icon(Icons.close),
                  ),
                  FloatingActionButton(
                    heroTag: "right",
                    onPressed: controller.swipeRight,
                    backgroundColor: Colors.green,
                    elevation: 0,
                    child: const Icon(Icons.done),
                  ),
                  FloatingActionButton(
                    heroTag: "undo",
                    onPressed: controller.undo,
                    elevation: 0,
                    child: const Icon(Icons.undo),
                  ),
                  FloatingActionButton(
                    heroTag: "finish",
                    onPressed: () {
                      _finalizarChamada();
                    },
                    backgroundColor: Colors.orange,
                    elevation: 0,
                    child: const Icon(Icons.save),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  bool _onSwipe(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
      ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name} / $direction. Now the card $currentIndex is on top',
    );
    return true;
  }

  bool _onUndo(
      int? previousIndex,
      int currentIndex,
      CardSwiperDirection direction,
      ) {
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    return true;
  }

  void _finalizarChamada() async {
    var requestBody = [
      {
        'alunoId': '82f58a70-eebb-4862-bf4f-4aa60f0ef9a3',
        'aulaId': '1bf5a684-21a0-453b-8e85-cf1670b48a1e',
        'disciplinaId': '077ece48-0a4c-4a7a-92e3-722fc510fc6e',
        'status': 'PRESENTE',
      },
      {
        'alunoId': 'bee33685-dd64-44db-8170-e87cbca64fe0',
        'aulaId': '1bf5a684-21a0-453b-8e85-cf1670b48a1e',
        'disciplinaId': '077ece48-0a4c-4a7a-92e3-722fc510fc6e',
        'status': 'PRESENTE',

      },
      {
        'alunoId': '04b80447-2192-432b-bcbb-46c46c95ca72',
        'aulaId': '1bf5a684-21a0-453b-8e85-cf1670b48a1e',
        'disciplinaId': '077ece48-0a4c-4a7a-92e3-722fc510fc6e',
        'status': 'AUSENTE',

      },
      {
        'alunoId': 'ec379140-9216-4f19-8283-44f0c82b0199',
        'aulaId': '1bf5a684-21a0-453b-8e85-cf1670b48a1e',
        'disciplinaId': '077ece48-0a4c-4a7a-92e3-722fc510fc6e',
        'status': 'PRESENTE',

      },
      {
        'alunoId': '6b0f5e47-981d-4230-8e6d-ea11c88b764e',
        'aulaId': '1bf5a684-21a0-453b-8e85-cf1670b48a1e',
        'disciplinaId': '077ece48-0a4c-4a7a-92e3-722fc510fc6e',
        'status': 'PRESENTE',

      },
      {
        'alunoId': '2cb6bb23-49d7-446f-b751-64913e0fafc3',
        'aulaId': '1bf5a684-21a0-453b-8e85-cf1670b48a1e',
        'disciplinaId': '077ece48-0a4c-4a7a-92e3-722fc510fc6e',
        'status': 'PRESENTE',

      }
    ];

    final response = await http.post(
      Uri.parse('${Environment.BASE_URL}/chamada/frequencias/finalizar'),
      body: json.encode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      _mostrarNotificacao(context);
      print('chamada finalizada');
    } else {
      print('erro ao finalizar chamada');
    }

  }

  void _mostrarNotificacao(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text("Chamada finalizada com sucesso."),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

