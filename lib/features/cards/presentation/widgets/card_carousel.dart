import 'package:flutter/material.dart';
import '../../domain/entities/bank_card.dart';
import 'bank_card_widget.dart';

class CardCarousel extends StatefulWidget {
  final List<BankCard> cards;
  final bool revealed;
  final void Function(int index)? onPageChanged;

  const CardCarousel({
    super.key,
    required this.cards,
    this.revealed = false,
    this.onPageChanged,
  });

  @override
  State<CardCarousel> createState() => CardCarouselState();
}

class CardCarouselState extends State<CardCarousel> {
  int _preferredStartIndex(int cardCount) => cardCount >= 3 ? 1 : 0;

  late final PageController controller = PageController(
    viewportFraction: 0.78,
    initialPage: _preferredStartIndex(widget.cards.length),
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        controller: controller,
        padEnds: true,
        itemCount: widget.cards.length,
        onPageChanged: widget.onPageChanged,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: BankCardWidget(
              card: widget.cards[index],
              revealed: widget.revealed,
            ),
          );
        },
      ),
    );
  }
}
