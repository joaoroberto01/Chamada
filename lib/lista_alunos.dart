import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    // colher os dados do server
    // _getStudentsFromClass();
  }

  Future<void> _getStudentsFromClass() async {
    final response = await http.get(Uri.parse('${Environment.BASE_URL}/chamada/alunos'));
    final data = jsonDecode(response.body);
    setState(() {
      // _message = data['message'];
    });
  }

  final CardSwiperController controller = CardSwiperController();

  // final cards = candidates.map((candidate) => ExampleCard(candidate)).toList();

  @override
  Widget build(BuildContext context) {
    Aula aula = widget.aula; // acessando a instância de 'Aula'
    var alunos;

    FutureBuilder<List<ExampleCandidateModel>>(
      future: fetchCandidates(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          alunos = snapshot.data!;
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new)
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
                onPressed: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Example(aula: aula)),
                  );*/
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
                cardsCount: alunos.length,
                numberOfCardsDisplayed: alunos.length,
                isLoop: false,
                onSwipe: _onSwipe,
                onUndo: _onUndo,
                onEnd: () {
                  print("ACABO");
                },
                padding: const EdgeInsets.all(24.0),
                cardBuilder: (context, index) => alunos[index],
                isVerticalSwipingEnabled: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // FloatingActionButton(
                  //   onPressed: controller.undo,
                  //   child: const Icon(Icons.rotate_left),
                  // ),
                  // FloatingActionButton(
                  //   onPressed: controller.swipe,
                  //   child: const Icon(Icons.rotate_right),
                  // ),
                  FloatingActionButton(
                    onPressed: controller.swipeLeft,
                    backgroundColor: Colors.red,
                    elevation: 0,
                    child: const Icon(Icons.close),
                  ),
                  FloatingActionButton(
                    onPressed: controller.swipeRight,
                    backgroundColor: Colors.green,
                    elevation: 0,
                    child: const Icon(Icons.done),
                  ),
                  FloatingActionButton(
                    onPressed: controller.undo,
                    elevation: 0,
                    child: const Icon(Icons.undo),
                  ),
                  // FloatingActionButton(
                  //   onPressed: controller.swipeTop,
                  //   child: const Icon(Icons.keyboard_arrow_up),
                  // ),
                  // FloatingActionButton(
                  //   onPressed: controller.swipeBottom,
                  //   child: const Icon(Icons.keyboard_arrow_down),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
