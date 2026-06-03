import 'package:flutter/material.dart';

class PlayingCard {
  String value;
  String suit;
  Color color;
  int points;

  PlayingCard({
    required this.value,
    required this.suit,
    required this.color,
    required this.points,
  });

  // Getter — full card name
  String get fullName => '$value of $suit';

  // Getter — color name
  String get colorName => color == Colors.red ? 'Red' : 'Black';

  // Method — is this a face card?
  bool isFaceCard() {
    return value == 'J' ||
        value == 'Q' ||
        value == 'K';
  }

  // Method — is this an Ace?
  bool isAce() {
    return value == 'A';
  }
}

// Builds and returns a full shuffled 52 card deck
List<PlayingCard> buildDeck() {
  List<PlayingCard> deck = [];

  // The four suits and whether they are red or black
  final suits = [
    {'symbol': '\u2660', 'color': Colors.black},  // ♠ Spades
    {'symbol': '\u2665', 'color': Colors.red},    // ♥ Hearts
    {'symbol': '\u2666', 'color': Colors.red},    // ♦ Diamonds
    {'symbol': '\u2663', 'color': Colors.black},  // ♣ Clubs
  ];

  // The 13 values and their point scores
  final values = [
    {'value': 'A',  'points': 14},
    {'value': '2',  'points': 2},
    {'value': '3',  'points': 3},
    {'value': '4',  'points': 4},
    {'value': '5',  'points': 5},
    {'value': '6',  'points': 6},
    {'value': '7',  'points': 7},
    {'value': '8',  'points': 8},
    {'value': '9',  'points': 9},
    {'value': '10', 'points': 10},
    {'value': 'J',  'points': 11},
    {'value': 'Q',  'points': 12},
    {'value': 'K',  'points': 13},
  ];

  // Nested loop — generates all 52 combinations
  for (var suit in suits) {
    for (var value in values) {
      deck.add(PlayingCard(
        value: value['value'] as String,
        suit: suit['symbol'] as String,
        color: suit['color'] as Color,
        points: value['points'] as int,
      ));
    }
  }

  // Shuffle the deck before returning it
  deck.shuffle();
  return deck;
}