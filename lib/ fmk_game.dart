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

  // Which card is being decided — null means none selected yet
  int? _selectedIndex;

  // Animation controllers
  late AnimationController _swipeController;
  late Animation<Offset> _swipeAnimation;
  FMKChoice? _pendingChoice;

  static const int totalTurns = 9;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_swipeController);
    _startGame();
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _deck = TarotDeck.buildShuffledDeck();
      _currentThree = TarotDeck.drawCards(_deck, 3);
      _history.clear();
      _turn = 1;
      _gameOver = false;
      _choosing = false;
      _selectedIndex = null;
    });
  }

  void _selectCard(int index) {
    if (_choosing) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  void _makeChoice(FMKChoice choice) {
    if (_selectedIndex == null || _choosing) return;

    final chosen = _currentThree[_selectedIndex!];
    setState(() {
      _choosing = true;
      _pendingChoice = choice;
    });

    // Brief delay to show the choice label then process
    Future.delayed(Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        // Record the turn
        _history.add(FMKTurn(card: chosen, choice: choice));

        // Remove chosen card from current three
        _currentThree.removeAt(_selectedIndex!);

        // Handle deck management
        if (choice == FMKChoice.kill) {
          // Killed — permanently removed, don't return to deck
        } else {
          // F or Marry — return to deck and reshuffle
          _deck.add(chosen);
          _deck.shuffle();
        }

        // Return unchosen cards to deck and reshuffle
        for (final card in _currentThree) {
          _deck.add(card);
        }
        _deck.shuffle();

        if (_turn >= totalTurns) {
          // Game over
          _gameOver = true;
        } else {
          // Next turn
          _turn++;
          _currentThree = TarotDeck.drawCards(_deck, 3);
          _selectedIndex = null;
          _choosing = false;
          _pendingChoice = null;
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

          SizedBox(height: 16),

          // Instruction text
          Text(
            _selectedIndex == null
                ? 'Tap a card to select it'
                : 'Now swipe or tap a choice below',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),

          SizedBox(height: 16),

          // Three cards
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(3, (i) => _buildCardSlot(i)),
            ),
          ),

          SizedBox(height: 16),

          // Choice buttons — only show when a card is selected
          if (_selectedIndex != null)
            _buildChoiceButtons(),

          SizedBox(height: 24),

          // Turn progress dots
          _buildProgressDots(),

          SizedBox(height: 24),

        ],
      ),
    );
  }

  Widget _buildCardSlot(int index) {
    final card = _currentThree[index];
    final isSelected = _selectedIndex == index;
    final hasSelection = _selectedIndex != null;
    final isChosen = _choosing && isSelected;

    return GestureDetector(
      onTap: () => _selectCard(index),
      onVerticalDragEnd: (details) {
        if (isSelected && details.primaryVelocity! < -300) {
          _makeChoice(FMKChoice.f);
        }
      },
      onHorizontalDragEnd: (details) {
        if (!isSelected) return;
        if (details.primaryVelocity! > 300) {
          _makeChoice(FMKChoice.marry);
        } else if (details.primaryVelocity! < -300) {
          _makeChoice(FMKChoice.kill);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(isSelected ? 1.08 : (hasSelection ? 0.92 : 1.0)),
        transformAlignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Card
            Opacity(
              opacity: hasSelection && !isSelected ? 0.5 : 1.0,
              child: TarotCardWidget(
                card: card,
                width: 120,
                height: 185,
              ),
            ),

            // Choice label overlay
            if (isChosen && _pendingChoice != null)
              Container(
                width: 120,
                height: 185,
                decoration: BoxDecoration(
                  color: _choiceColor(_pendingChoice!).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    _choiceLabel(_pendingChoice!),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceButtons() {
    return Column(
      children: [
        // F button (up)
        _buildChoiceButton(
          label: '💋 F',
          color: Color(0xFFE91E8C),
          onTap: () => _makeChoice(FMKChoice.f),
          hint: 'swipe up',
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Kill button (left)
            _buildChoiceButton(
              label: '💀 Kill',
              color: Color(0xFF8B0000),
              onTap: () => _makeChoice(FMKChoice.kill),
              hint: 'swipe left',
            ),
            SizedBox(width: 16),
            // Marry button (right)
            _buildChoiceButton(
              label: '💍 Marry',
              color: Color(0xFF1B4D1B),
              onTap: () => _makeChoice(FMKChoice.marry),
              hint: 'swipe right',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChoiceButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
    required String hint,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              hint,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 10,
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
        final done = i < _history.length;
        final current = i == _history.length && !_gameOver;
        Color dotColor;
        if (done) {
          final choice = _history[i].choice;
          dotColor = _choiceColor(choice);
        } else if (current) {
          dotColor = Colors.white;
        } else {
          dotColor = Colors.white24;
        }
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: current ? 12 : 8,
          height: current ? 12 : 8,
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
        title: Text(
          'In Memorial',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [

          SizedBox(height: 24),

          // Candle emoji header
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

          // Grid of killed cards
          Expanded(
            child: killed.isEmpty
                ? Center(
                    child: Text(
                      'No cards were killed!',
                      style: TextStyle(color: Colors.white38, fontSize: 16),
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
                          // Greyscale card
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
                          // RIP overlay
                          Positioned(
                            bottom: 40,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
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

          // Play again button
          ElevatedButton(
            onPressed: () {
              setState(() {
                _startGame();
              });
            },
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
      case FMKChoice.f:     return '💋 F';
      case FMKChoice.marry: return '💍 Marry';
      case FMKChoice.kill:  return '💀 Kill';
    }
  }
}