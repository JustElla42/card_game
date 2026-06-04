import 'package:flutter/material.dart';
import 'playing_card.dart';
import 'card_border.dart';
import 'tarot_card_widget.dart';
import 'tarot_deck.dart';
import 'fmk_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'War Card Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String player1Name = 'Player 1';
  String player2Name = 'Player 2';

  List<PlayingCard> player1Hand = [];
  List<PlayingCard> player2Hand = [];
  List<PlayingCard> discardPile = [];

  PlayingCard? player1Card;
  PlayingCard? player2Card;

  String roundWinner = '';
  bool gameOver = false;
  String winner = '';
  bool roundPlayed = false;
  int roundNumber = 0;
  bool player1Wins = false;
  bool player2Wins = false;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      List<PlayingCard> deck = buildDeck();
      player1Hand = deck.sublist(0, 26);
      player2Hand = deck.sublist(26, 52);
      discardPile = [];
      player1Card = null;
      player2Card = null;
      roundWinner = '';
      gameOver = false;
      winner = '';
      roundPlayed = false;
      roundNumber = 0;
      player1Wins = false;
      player2Wins = false;
    });
  }

  void _playRound() {
    if (gameOver) return;
    if (player1Hand.isEmpty || player2Hand.isEmpty) return;

    setState(() {
      roundNumber++;

      player1Card = player1Hand.removeAt(0);
      player2Card = player2Hand.removeAt(0);

      if (player1Card!.points > player2Card!.points) {
        roundWinner = '$player1Name wins this round!';
        player1Hand.add(player1Card!);
        discardPile.add(player2Card!);
        player1Wins = true;
        player2Wins = false;
      } else if (player2Card!.points > player1Card!.points) {
        roundWinner = '$player2Name wins this round!';
        player2Hand.add(player2Card!);
        discardPile.add(player1Card!);
        player1Wins = false;
        player2Wins = true;
      } else {
        roundWinner = 'Tie! Both cards discarded.';
        discardPile.add(player1Card!);
        discardPile.add(player2Card!);
        player1Wins = false;
        player2Wins = false;
      }

      roundPlayed = true;

      if (player1Hand.isEmpty) {
        gameOver = true;
        winner = '$player2Name wins the game!';
      } else if (player2Hand.isEmpty) {
        gameOver = true;
        winner = '$player1Name wins the game!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      appBar: AppBar(
        title: Text('War'),
        backgroundColor: Colors.red.shade800,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [

              // Game over banner
              if (gameOver)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    winner,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // Round info
              Text(
                gameOver
                    ? 'Game Over!'
                    : roundPlayed
                        ? 'Round $roundNumber — $roundWinner'
                        : 'Tap the card to play a round!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              // Player stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPlayerInfo(
                    player1Name,
                    player1Hand.length,
                    Colors.blue.shade300,
                  ),
                  Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildPlayerInfo(
                    player2Name,
                    player2Hand.length,
                    Colors.orange.shade300,
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Cards row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: gameOver ? null : _playRound,
                    child: _buildCardWidget(
                      player1Card,
                      Colors.blue.shade100,
                      player1Name,
                      player1Wins,
                    ),
                  ),
                  _buildCardWidget(
                    player2Card,
                    Colors.orange.shade100,
                    player2Name,
                    player2Wins,
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Discard pile info
              if (discardPile.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Discard pile: ${discardPile.length} cards',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),

              SizedBox(height: 16),

              // New Game button
              ElevatedButton(
                onPressed: _startNewGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade800,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'New Game',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              SizedBox(height: 12),

              // F Marry Kill button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FMKGameScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A1B8B),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Play F, Marry, Kill',
                  style: TextStyle(fontSize: 16),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerInfo(String name, int cardCount, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            '$cardCount cards',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWidget(
    PlayingCard? card,
    Color backgroundColor,
    String playerName,
    bool isWinner,
  ) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: isWinner ? 170 : 150,
      height: isWinner ? 250 : 220,
      decoration: BoxDecoration(
        color: card == null ? Colors.white24 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isWinner
                ? Colors.amber.withValues(alpha: 0.8)
                : Colors.black38,
            blurRadius: isWinner ? 24 : 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: card == null
          ? Center(
              child: Text(
                player1Card == null ? 'Tap to play!' : playerName,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            card.value,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: card.color,
                            ),
                          ),
                          Text(
                            card.suit,
                            style: TextStyle(
                              fontSize: 16,
                              color: card.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    card.suit,
                    style: TextStyle(
                      fontSize: 56,
                      color: card.color,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Text(
                            card.suit,
                            style: TextStyle(
                              fontSize: 16,
                              color: card.color,
                            ),
                          ),
                          Text(
                            card.value,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: card.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}