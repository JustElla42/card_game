import 'dart:math';
import 'tarot_card.dart';

// ─── Minor arcana card names ───────────────────────────────────

const List<String> _minorNames = [
  'Ace', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven',
  'Eight', 'Nine', 'Ten', 'Page', 'Knight', 'Queen', 'King',
];

const List<String> _minorTopBanners = [
  'The beginning',   // Ace
  'The pair',        // Two
  'The triangle',    // Three
  'The foundation',  // Four
  'The challenge',   // Five
  'The harmony',     // Six
  'The seeker',      // Seven
  'The movement',    // Eight
  'The approach',    // Nine
  'The completion',  // Ten
  'The student',     // Page
  'The journey',     // Knight
  'The matriarch',   // Queen
  'The patriarch',   // King
];

// ─── Major arcana ─────────────────────────────────────────────

const List<Map<String, dynamic>> _majorArcana = [
  {'number': 0,  'name': 'The Fool',          'banner': 'The beginning'},
  {'number': 1,  'name': 'The Magician',       'banner': 'The will'},
  {'number': 2,  'name': 'The High Priestess', 'banner': 'The mystery'},
  {'number': 3,  'name': 'The Empress',        'banner': 'The abundance'},
  {'number': 4,  'name': 'The Emperor',        'banner': 'The authority'},
  {'number': 5,  'name': 'The Hierophant',     'banner': 'The tradition'},
  {'number': 6,  'name': 'The Lovers',         'banner': 'The union'},
  {'number': 7,  'name': 'The Chariot',        'banner': 'The victory'},
  {'number': 8,  'name': 'Strength',           'banner': 'The courage'},
  {'number': 9,  'name': 'The Hermit',         'banner': 'The solitude'},
  {'number': 10, 'name': 'Wheel of Fortune',   'banner': 'The cycle'},
  {'number': 11, 'name': 'Justice',            'banner': 'The balance'},
  {'number': 12, 'name': 'The Hanged Man',     'banner': 'The surrender'},
  {'number': 13, 'name': 'Death',              'banner': 'The transformation'},
  {'number': 14, 'name': 'Temperance',         'banner': 'The patience'},
  {'number': 15, 'name': 'The Devil',          'banner': 'The shadow'},
  {'number': 16, 'name': 'The Tower',          'banner': 'The upheaval'},
  {'number': 17, 'name': 'The Star',           'banner': 'The hope'},
  {'number': 18, 'name': 'The Moon',           'banner': 'The illusion'},
  {'number': 19, 'name': 'The Sun',            'banner': 'The clarity'},
  {'number': 20, 'name': 'Judgement',          'banner': 'The awakening'},
  {'number': 21, 'name': 'The World',          'banner': 'The completion'},
];

// ─── Deck builder ─────────────────────────────────────────────

class TarotDeck {
  // The full 78-card deck
  static List<TarotCard> buildFullDeck() {
    final List<TarotCard> deck = [];

    // Build 56 minor arcana — 14 cards per suit
    for (final suit in TarotSuit.values) {
      for (int i = 0; i < 14; i++) {
        deck.add(TarotCard(
          name: _minorNames[i],
          topBanner: _minorTopBanners[i],
          arcana: TarotArcana.minor,
          suit: suit,
          suitNumber: i + 1,
          artworkAsset: _minorArtworkPath(suit, i + 1),
          // Stats all 0 until assigned
          statA: 0,
          statB: 0,
          statC: 0,
          statD: 0,
          keywords: _minorKeywords(suit, i + 1),
        ));
      }
    }

    // Build 22 major arcana
    for (final card in _majorArcana) {
      deck.add(TarotCard(
        name: card['name'] as String,
        topBanner: card['banner'] as String,
        arcana: TarotArcana.major,
        majorNumber: card['number'] as int,
        artworkAsset: _majorArtworkPath(card['number'] as int),
        // Stats all 0 until assigned
        statA: 0,
        statB: 0,
        statC: 0,
        statD: 0,
        keywords: [],
      ));
    }

    return deck;
  }

  // Shuffled copy of the full deck
  static List<TarotCard> buildShuffledDeck() {
    final deck = buildFullDeck();
    deck.shuffle(Random());
    return deck;
  }

  // Filter by suit
  static List<TarotCard> getSuit(
      List<TarotCard> deck,
      TarotSuit suit,
      ) {
    return deck
        .where((card) => card.suit == suit)
        .toList();
  }

  // Get major arcana only
  static List<TarotCard> getMajorArcana(List<TarotCard> deck) {
    return deck
        .where((card) => card.isMajorArcana)
        .toList();
  }

  // Get minor arcana only
  static List<TarotCard> getMinorArcana(List<TarotCard> deck) {
    return deck
        .where((card) => card.isMinorArcana)
        .toList();
  }

  // Draw top card
  static TarotCard? drawCard(List<TarotCard> deck) {
    if (deck.isEmpty) return null;
    return deck.removeAt(0);
  }

  // Draw multiple cards
  static List<TarotCard> drawCards(List<TarotCard> deck, int count) {
    final drawn = <TarotCard>[];
    for (int i = 0; i < count && deck.isNotEmpty; i++) {
      drawn.add(deck.removeAt(0));
    }
    return drawn;
  }
}

// ─── Artwork path helpers ──────────────────────────────────────
// Returns placeholder path now — swap for real image path later
// When art is ready, images go in assets/artwork/minor/ and assets/artwork/major/
// Naming convention: balls_01.png, holes_king.png, major_00_fool.png etc

String _minorArtworkPath(TarotSuit suit, int number) {
  final suitName = suit.displayName.toLowerCase();
  final num = number.toString().padLeft(2, '0');
  return 'assets/artwork/minor/${suitName}_$num.png';
}

String _majorArtworkPath(int number) {
  final num = number.toString().padLeft(2, '0');
  return 'assets/artwork/major/major_$num.png';
}

// ─── Keyword helpers ───────────────────────────────────────────
// Placeholder keywords per card — expand as needed

List<String> _minorKeywords(TarotSuit suit, int number) {
  // Returns basic keywords based on card number
  // These can be expanded per card later
  const baseKeywords = [
    ['beginning', 'potential', 'seed'],        // Ace
    ['duality', 'choice', 'balance'],           // Two
    ['growth', 'creativity', 'collaboration'],  // Three
    ['stability', 'foundation', 'rest'],        // Four
    ['conflict', 'challenge', 'change'],        // Five
    ['harmony', 'reunion', 'nostalgia'],        // Six
    ['reflection', 'seeking', 'perseverance'],  // Seven
    ['movement', 'action', 'speed'],            // Eight
    ['fulfillment', 'approach', 'readiness'],   // Nine
    ['completion', 'end', 'wholeness'],         // Ten
    ['curiosity', 'learning', 'youth'],         // Page
    ['adventure', 'action', 'courage'],         // Knight
    ['nurturing', 'intuition', 'wisdom'],       // Queen
    ['authority', 'mastery', 'leadership'],     // King
  ];
  return baseKeywords[number - 1];
}