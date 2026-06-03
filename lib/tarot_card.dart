import 'package:flutter/material.dart';

// ─── Enums ────────────────────────────────────────────────────

enum TarotArcana { minor, major }

enum TarotSuit { balls, paddles, holes, knots }

// ─── Suit helpers ─────────────────────────────────────────────

extension TarotSuitExtension on TarotSuit {
  String get displayName {
    switch (this) {
      case TarotSuit.balls:   return 'Balls';
      case TarotSuit.paddles: return 'Paddles';
      case TarotSuit.holes:   return 'Holes';
      case TarotSuit.knots:   return 'Knots';
    }
  }

  String get symbol {
    switch (this) {
      case TarotSuit.balls:   return '\u{1F534}';
      case TarotSuit.paddles: return '\u{1F3CF}';
      case TarotSuit.holes:   return '✺';
      case TarotSuit.knots:   return '\u{1FAA2}';
    }
  }

  Color get color {
    switch (this) {
      case TarotSuit.balls:   return Color(0xFF1A3A6B);
      case TarotSuit.paddles: return Color(0xFF1B4D1B);
      case TarotSuit.holes:   return Color(0xFF8B0000);
      case TarotSuit.knots:   return Color(0xFFB8960C);
    }
  }
}

// ─── Card model ───────────────────────────────────────────────

class TarotCard {
  // Identity
  final String name;           // 'Ace of Holes', 'The World' etc
  final String topBanner;      // secondary text on top banner
  final TarotArcana arcana;    // minor or major
  final TarotSuit? suit;       // null for major arcana
  final int? suitNumber;       // 1-14 for minor arcana, null for major
  final int? majorNumber;      // 0-21 for major arcana, null for minor

  // Artwork — placeholder path, real image added later
  final String artworkAsset;

  // Corner stats — four permanent card attributes
  // Names TBD — using placeholders until stat categories decided
  final int statA;   // top left
  final int statB;   // top right
  final int statC;   // bottom left
  final int statD;   // bottom right

  // Optional card lore
  final String? description;
  final List<String> keywords;

  const TarotCard({
    required this.name,
    required this.topBanner,
    required this.arcana,
    required this.artworkAsset,
    this.suit,
    this.suitNumber,
    this.majorNumber,
    this.statA = 0,
    this.statB = 0,
    this.statC = 0,
    this.statD = 0,
    this.description,
    this.keywords = const [],
  });

  // Whether this is a major arcana card
  bool get isMajorArcana => arcana == TarotArcana.major;

  // Whether this is a minor arcana card
  bool get isMinorArcana => arcana == TarotArcana.minor;

  // Full display name including suit for minor arcana
  String get fullName => isMajorArcana
      ? name
      : '$name of ${suit!.displayName}';

  // Roman numeral for major arcana
  String get romanNumeral {
    if (!isMajorArcana || majorNumber == null) return '';
    const numerals = [
      '0', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII',
      'VIII', 'IX', 'X', 'XI', 'XII', 'XIII', 'XIV',
      'XV', 'XVI', 'XVII', 'XVIII', 'XIX', 'XX', 'XXI'
    ];
    return numerals[majorNumber!];
  }
}