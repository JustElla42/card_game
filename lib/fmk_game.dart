import 'package:flutter/material.dart';
import 'tarot_card.dart';
import 'tarot_deck.dart';
import 'tarot_card_widget.dart';

// ─── Game State ───────────────────────────────────────────────

enum FMKChoice { f, marry, kill }

class FMKTurn {
  final TarotCard card;
  final FMKChoice choice;

  FMKTurn({required this.card, required this.choice});
}

// ─── Main Game Screen ─────────────────────────────────────────

class FMKGameScreen extends StatefulWidget {
  const FMKGameScreen({super.key});

  @override
  State<FMKGameScreen> createState() => _FMKGameScreenState();
}

class _FMKGameScreenState extends State<FMKGameScreen>
    with TickerProviderStateMixin {

  // Game data
  late List<TarotCard> _deck;
  late List<TarotCard> _currentThree;
  final List<FMKTurn> _history = [];
  int _turn = 1;
  bool _gameOver = false;
  bool _choosing = false;
  final Map<int, FMKChoice> _turnChoices = {};

  static const int totalTurns = 9;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    setState(() {
      _deck = TarotDeck.buildShuffledDeck();
      _currentThree = TarotDeck.drawCards(_deck, 3);
      _history.clear();
      _turn = 1;
      _gameOver = false;
      _choosing = false;
      _turnChoices.clear();
    });
  }

void _makeChoice(int cardIndex, FMKChoice choice) {
    if (_choosing) return;
    if (_turnChoices.containsKey(cardIndex)) return;

    if (_turnChoices.values.contains(choice)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_choiceLabel(choice)} is already assigned this turn!',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 1),
          backgroundColor: _choiceColor(choice),
        ),
      );
      return;
    }

    setState(() {
      _turnChoices[cardIndex] = choice;

      // If 2 cards assigned, auto-assign the third
      if (_turnChoices.length == 2) {
        // Find the remaining unassigned card index
        final unassignedIndex = List.generate(3, (i) => i)
            .firstWhere((i) => !_turnChoices.containsKey(i));

        // Find the remaining unused choice
        final usedChoices = _turnChoices.values.toSet();
        final remainingChoice = FMKChoice.values
            .firstWhere((c) => !usedChoices.contains(c));

        _turnChoices[unassignedIndex] = remainingChoice;
      }
    });

    if (_turnChoices.length == 3) {
      _processTurn();
    }
  }

  void _processTurn() {
    setState(() {
      _choosing = true;
    });

    Future.delayed(Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        for (final entry in _turnChoices.entries) {
          final card = _currentThree[entry.key];
          final choice = entry.value;

          _history.add(FMKTurn(card: card, choice: choice));

          if (choice != FMKChoice.kill) {
            _deck.add(card);
          }
        }

        _deck.shuffle();

        if (_turn >= totalTurns) {
          _gameOver = true;
        } else {
          _turn++;
          _currentThree = TarotDeck.drawCards(_deck, 3);
          _turnChoices.clear();
          _choosing = false;
        }
      });
    });
  }

  List<TarotCard> get _killedCards =>
      _history
          .where((t) => t.choice == FMKChoice.kill)
          .map((t) => t.card)
          .toList();

  // ─── Build ────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_gameOver) return _buildMemorialScreen();
    return _buildGameScreen();
  }

  Widget _buildGameScreen() {
    final remaining = 3 - _turnChoices.length;

    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Color(0xFF4A1B8B),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Turn $_turn of $totalTurns',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [

          // ── Top target — F ──────────────────────────────
          _buildTopTarget(),

          // ── Middle row — Kill | Cards | Marry ───────────
          Expanded(
            child: Row(
              children: [

                // Left target — Kill
                _buildSideTarget(
                  label: 'Kill',
                  icon: '💀',
                  color: Color(0xFF8B0000),
                ),

                // Cards
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(3, (i) => _buildCardSlot(i)),
                  ),
                ),

                // Right target — Marry
                _buildSideTarget(
                  label: 'Marry',
                  icon: '💍',
                  color: Color(0xFF1B4D1B),
                ),

              ],
            ),
          ),

          // ── Status text ──────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              _choosing
                  ? 'Resolving...'
                  : remaining == 3
                      ? 'Swipe each card to assign'
                      : '$remaining card${remaining == 1 ? '' : 's'} left to assign',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          // ── Progress dots ────────────────────────────────
          _buildProgressDots(),

          SizedBox(height: 24),

        ],
      ),
    );
  }

  // Top F target
  Widget _buildTopTarget() {
    final used = _turnChoices.values.contains(FMKChoice.f);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: used
            ? Color(0xFFE91E8C).withValues(alpha: 0.5)
            : Color(0xFFE91E8C).withValues(alpha: 0.15),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE91E8C).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('💋', style: TextStyle(fontSize: 28)),
          SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'F',
                style: TextStyle(
                  color: used ? Colors.white : Color(0xFFE91E8C),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'swipe up',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          if (used) ...[
            SizedBox(width: 8),
            Icon(Icons.check_circle, color: Colors.white54, size: 16),
          ],
        ],
      ),
    );
  }

  // Side target — Kill (left) or Marry (right)
  Widget _buildSideTarget({
    required String label,
    required String icon,
    required Color color,
  }) {
    final choice = label == 'Kill' ? FMKChoice.kill : FMKChoice.marry;
    final used = _turnChoices.values.contains(choice);
    final isLeft = label == 'Kill';

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: 52,
      decoration: BoxDecoration(
        color: used
            ? color.withValues(alpha: 0.5)
            : color.withValues(alpha: 0.15),
        border: Border(
          right: isLeft
              ? BorderSide(color: color.withValues(alpha: 0.3), width: 1)
              : BorderSide.none,
          left: !isLeft
              ? BorderSide(color: color.withValues(alpha: 0.3), width: 1)
              : BorderSide.none,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          RotatedBox(
            quarterTurns: isLeft ? -1 : 1,
            child: Text(
              label,
              style: TextStyle(
                color: used ? Colors.white : color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          SizedBox(height: 8),
          RotatedBox(
            quarterTurns: isLeft ? -1 : 1,
            child: Text(
              isLeft ? 'swipe left' : 'swipe right',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 8,
              ),
            ),
          ),
          if (used) ...[
            SizedBox(height: 8),
            Icon(Icons.check_circle, color: Colors.white54, size: 14),
          ],
        ],
      ),
    );
  }

  Widget _buildCardSlot(int index) {
    final card = _currentThree[index];
    final assignedChoice = _turnChoices[index];

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (_choosing) return;
        if (assignedChoice != null) return;
        if (details.primaryVelocity! < -300) {
          _makeChoice(index, FMKChoice.f);
        }
      },
      onHorizontalDragEnd: (details) {
        if (_choosing) return;
        if (assignedChoice != null) return;
        if (details.primaryVelocity! > 300) {
          _makeChoice(index, FMKChoice.marry);
        } else if (details.primaryVelocity! < -300) {
          _makeChoice(index, FMKChoice.kill);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child: Stack(
          alignment: Alignment.center,
          children: [

            // Card
            Opacity(
              opacity: assignedChoice != null ? 0.6 : 1.0,
              child: TarotCardWidget(
                card: card,
                width: 100,
                height: 155,
              ),
            ),

            // Assignment label overlay
            if (assignedChoice != null)
              Container(
                width: 100,
                height: 155,
                decoration: BoxDecoration(
                  color: _choiceColor(assignedChoice).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _choiceIcon(assignedChoice),
                        style: TextStyle(fontSize: 28),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _choiceLabel(assignedChoice),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }

  Widget _buildProgressDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalTurns, (i) {
        final isDone = i < (_turn - 1);
        final isCurrent = i == (_turn - 1) && !_gameOver;
        Color dotColor;
        if (isDone) {
          dotColor = Color(0xFF4A1B8B);
        } else if (isCurrent) {
          dotColor = Colors.white;
        } else {
          dotColor = Colors.white24;
        }
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: isCurrent ? 12 : 8,
          height: isCurrent ? 12 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        );
      }),
    );
  }

  // ─── Memorial Screen ──────────────────────────────────────

  Widget _buildMemorialScreen() {
    final killed = _killedCards;

    return Scaffold(
      backgroundColor: Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A0000),
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'In Memorial',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [

          SizedBox(height: 24),

          Text('🕯️  🕯️  🕯️', style: TextStyle(fontSize: 28)),
          SizedBox(height: 8),
          Text(
            'Departed this game',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              letterSpacing: 1,
            ),
          ),

          SizedBox(height: 24),

          Expanded(
            child: killed.isEmpty
                ? Center(
                    child: Text(
                      'No cards were killed!',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 16,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 220 / 340,
                    ),
                    itemCount: killed.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          ColorFiltered(
                            colorFilter: ColorFilter.matrix([
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0,      0,      0,      1, 0,
                            ]),
                            child: TarotCardWidget(
                              card: killed[index],
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            bottom: 40,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'R.I.P.',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),

          SizedBox(height: 16),

          ElevatedButton(
            onPressed: () => setState(() => _startGame()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4A1B8B),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            ),
            child: Text(
              'Play Again',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 32),

        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────

  Color _choiceColor(FMKChoice choice) {
    switch (choice) {
      case FMKChoice.f:     return Color(0xFFE91E8C);
      case FMKChoice.marry: return Color(0xFF1B4D1B);
      case FMKChoice.kill:  return Color(0xFF8B0000);
    }
  }

  String _choiceLabel(FMKChoice choice) {
    switch (choice) {
      case FMKChoice.f:     return 'F';
      case FMKChoice.marry: return 'Marry';
      case FMKChoice.kill:  return 'Kill';
    }
  }

  String _choiceIcon(FMKChoice choice) {
    switch (choice) {
      case FMKChoice.f:     return '💋';
      case FMKChoice.marry: return '💍';
      case FMKChoice.kill:  return '💀';
    }
  }
}