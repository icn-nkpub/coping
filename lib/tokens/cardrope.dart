import 'package:flutter/material.dart';

class RopedCard extends StatelessWidget {
  const RopedCard({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class CardRope extends StatelessWidget {
  const CardRope({
    super.key,
    required this.cards,
  });

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    List<Widget> ws = [];
    for (var card in cards) {
      ws.add(const SizedBox(
        height: 8,
      ));
      ws.add(card);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        shrinkWrap: true,
        reverse: true,
        children: ws.reversed.toList(),
      ),
    );
  }
}
