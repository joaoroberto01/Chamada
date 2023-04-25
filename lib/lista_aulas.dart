import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'example_card.dart';
import 'example_candidate_model.dart';

class Example extends StatefulWidget {
  const Example({
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
    return Scaffold(
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
                  print("ACABO");
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
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
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
