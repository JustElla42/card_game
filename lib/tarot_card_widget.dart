import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'tarot_card.dart';
import 'card_themes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TarotCardWidget extends StatelessWidget {
  final TarotCard card;
  final double width;
  final double height;
  final bool showBack;

  const TarotCardWidget({
    super.key,
    required this.card,
    this.width = 220,
    this.height = 340,
    this.showBack = false,
  });

  // ─── SVG corner flourish ──────────────────────────────────
  static const String _cornerSvg =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">'
      '<path d="M 20 98 C 20 75 17 55 20 36" stroke="black" stroke-width="2.5" fill="none"/>'
      '<path d="M 98 20 C 75 20 55 17 36 20" stroke="black" stroke-width="2.5" fill="none"/>'
      '<path d="M 20 36 C 20 22 12 14 5 7 C 2 4 5 1 10 3 C 17 6 24 13 32 17" stroke="black" stroke-width="2.2" fill="none"/>'
      '<path d="M 14 28 C 8 20 7 10 15 8 C 23 6 30 14 28 22 C 26 30 17 33 14 28 Z" stroke="black" stroke-width="1.8" fill="none"/>'
      '<path d="M 20 54 C 36 52 44 42 36 38 C 28 34 14 38 16 50 C 17 57 26 60 32 54 C 38 48 36 40 30 42" stroke="black" stroke-width="1.8" fill="none"/>'
      '<path d="M 20 74 C 36 72 42 62 34 59 C 26 56 14 60 16 71 C 17 77 26 80 32 74 C 38 68 36 60 30 62" stroke="black" stroke-width="1.8" fill="none"/>'
      '<path d="M 54 20 C 52 36 42 44 38 36 C 34 28 38 14 50 16 C 57 17 60 26 54 32 C 48 38 40 36 42 30" stroke="black" stroke-width="1.8" fill="none"/>'
      '<path d="M 74 20 C 72 36 62 42 59 34 C 56 26 60 14 71 16 C 77 17 80 26 74 32 C 68 38 60 36 62 30" stroke="black" stroke-width="1.8" fill="none"/>'
      '<circle cx="20" cy="98" r="2.5" fill="black"/>'
      '<circle cx="98" cy="20" r="2.5" fill="black"/>'
      '<circle cx="36" cy="38" r="1.8" fill="black"/>'
      '<circle cx="34" cy="59" r="1.8" fill="black"/>'
      '<circle cx="38" cy="14" r="1.8" fill="black"/>'
      '<circle cx="59" cy="34" r="1.8" fill="black"/>'
      '</svg>';

  // ─── Theme ────────────────────────────────────────────────

  Color get _borderColor {
    if (card.isMajorArcana) return Color(0xFF4A1B8B);
    return card.suit!.color;
  }

  Color get _backgroundColor {
    if (card.isMajorArcana) return Color(0xFF1A1A2E);
    switch (card.suit!) {
      case TarotSuit.balls:   return Color(0xFFF0F4FF);
      case TarotSuit.paddles: return Color(0xFFF0F5F0);
      case TarotSuit.holes:   return Color(0xFFFFF0F0);
      case TarotSuit.knots:   return Color(0xFFF5E6C8);
    }
  }

  Color get _bannerColor => _borderColor;

  Color get _textColor {
    if (card.isMajorArcana) return Color(0xFFB8960C);
    return card.suit!.color;
  }

  // ─── Helper widgets ───────────────────────────────────────

  // Corner stat container — empty circle placeholder
  Widget _buildStatContainer() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _backgroundColor,
        border: Border.all(
          color: _borderColor,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          '—',
          style: TextStyle(
            fontSize: 12,
            color: _borderColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Corner flourish with stat container overlaid
  Widget _buildCorner({required double rotation}) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        children: [
          Transform.rotate(
            angle: rotation,
            child: SvgPicture.string(
              _cornerSvg,
              width: 80,
              height: 80,
              colorFilter: ColorFilter.mode(
                _borderColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: _buildStatContainer(),
            ),
          ),
        ],
      ),
    );
  }

  // Banner — top and bottom
  Widget _buildBanner(String text, {bool flipped = false}) {
    return Transform.rotate(
      angle: flipped ? math.pi : 0,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: _bannerColor,
          borderRadius: flipped
              ? BorderRadius.only(
            topLeft: Radius.circular(13),
            topRight: Radius.circular(13),
          )
              : BorderRadius.only(
            bottomLeft: Radius.circular(13),
            bottomRight: Radius.circular(13),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }

  // Artwork placeholder — colored block with suit symbol or arcana number
  Widget _buildArtworkPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: _borderColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _borderColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Suit symbol or Roman numeral
            Text(
              card.isMajorArcana
                  ? card.romanNumeral
                  : card.suit!.symbol,
              style: TextStyle(
                fontSize: card.isMajorArcana ? 32 : 48,
                color: _borderColor.withValues(alpha: 0.4),
              ),
            ),
            SizedBox(height: 8),
            // Artwork pending label
            Text(
              'Artwork\ncoming soon',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: _borderColor.withValues(alpha: 0.3),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card back design
  Widget _buildCardBack() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF4A1B8B),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '✵',
              style: TextStyle(
                fontSize: 64,
                color: Color(0xFF4A1B8B),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '✵  ✵  ✵',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF4A1B8B),
                letterSpacing: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Main build ───────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (showBack) return _buildCardBack();

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _borderColor,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          children: [

            // Layer 1 — inner border frame
            Positioned.fill(
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _borderColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            // Layer 2 — top banner (flipped)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildBanner(card.topBanner, flipped: true),
            ),

            // Layer 3 — bottom banner (card name)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBanner(card.name),
            ),

            // Layer 4 — top left corner
            Positioned(
              top: 36,
              left: 0,
              child: _buildCorner(rotation: 0),
            ),

            // Layer 5 — top right corner
            Positioned(
              top: 36,
              right: 0,
              child: _buildCorner(rotation: math.pi / 2),
            ),

            // Layer 6 — bottom left corner
            Positioned(
              bottom: 36,
              left: 0,
              child: _buildCorner(rotation: math.pi * 1.5),
            ),

            // Layer 7 — bottom right corner
            Positioned(
              bottom: 36,
              right: 0,
              child: _buildCorner(rotation: math.pi),
            ),

            // Layer 8 — center artwork area
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 48, 20, 48),
                child: _buildArtworkPlaceholder(),
              ),
            ),

          ],
        ),
      ),
    );
  }
}