import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'tarot_card.dart';
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

  // ─── Suit frame SVGs ─────────────────────────────────────
  // One frame per suit — overlaid on top of background image
  // Replace these with real suit frame SVGs when ready

  static const String _frameSvgBalls =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 220 340" preserveAspectRatio="none">'
      '<rect x="2" y="2" width="216" height="336" rx="14" ry="14" stroke="#1A3A6B" stroke-width="4" fill="none"/>'
      '<rect x="10" y="10" width="200" height="320" rx="10" ry="10" stroke="#1A3A6B" stroke-width="1.5" fill="none"/>'
      '</svg>';

  static const String _frameSvgPaddles =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 220 340" preserveAspectRatio="none">'
      '<rect x="2" y="2" width="216" height="336" rx="14" ry="14" stroke="#1B4D1B" stroke-width="4" fill="none"/>'
      '<rect x="10" y="10" width="200" height="320" rx="10" ry="10" stroke="#1B4D1B" stroke-width="1.5" fill="none"/>'
      '</svg>';

  static const String _frameSvgHoles =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 220 340" preserveAspectRatio="none">'
      '<rect x="2" y="2" width="216" height="336" rx="14" ry="14" stroke="#8B0000" stroke-width="4" fill="none"/>'
      '<rect x="10" y="10" width="200" height="320" rx="10" ry="10" stroke="#8B0000" stroke-width="1.5" fill="none"/>'
      '</svg>';

  static const String _frameSvgKnots =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 220 340" preserveAspectRatio="none">'
      '<rect x="2" y="2" width="216" height="336" rx="14" ry="14" stroke="#B8960C" stroke-width="4" fill="none"/>'
      '<rect x="10" y="10" width="200" height="320" rx="10" ry="10" stroke="#B8960C" stroke-width="1.5" fill="none"/>'
      '</svg>';

  static const String _frameSvgMajor =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 220 340" preserveAspectRatio="none">'
      '<rect x="2" y="2" width="216" height="336" rx="14" ry="14" stroke="#4A1B8B" stroke-width="4" fill="none"/>'
      '<rect x="10" y="10" width="200" height="320" rx="10" ry="10" stroke="#4A1B8B" stroke-width="1.5" fill="none"/>'
      '</svg>';

  // ─── Corner flourish SVG ──────────────────────────────────
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

  // ─── Theme colours ────────────────────────────────────────

  Color get _borderColor {
    if (card.isMajorArcana) return Color(0xFF4A1B8B);
    switch (card.suit!) {
      case TarotSuit.balls:   return Color(0xFF1A3A6B);
      case TarotSuit.paddles: return Color(0xFF1B4D1B);
      case TarotSuit.holes:   return Color(0xFF8B0000);
      case TarotSuit.knots:   return Color(0xFFB8960C);
    }
  }

  Color get _placeholderColor {
    if (card.isMajorArcana) return Color(0xFF2D1B5E);
    switch (card.suit!) {
      case TarotSuit.balls:   return Color(0xFF1A3A6B);
      case TarotSuit.paddles: return Color(0xFF1B4D1B);
      case TarotSuit.holes:   return Color(0xFF8B0000);
      case TarotSuit.knots:   return Color(0xFF8B6914);
    }
  }

  String get _frameSvg {
    if (card.isMajorArcana) return _frameSvgMajor;
    switch (card.suit!) {
      case TarotSuit.balls:   return _frameSvgBalls;
      case TarotSuit.paddles: return _frameSvgPaddles;
      case TarotSuit.holes:   return _frameSvgHoles;
      case TarotSuit.knots:   return _frameSvgKnots;
    }
  }

  // ─── Helper widgets ───────────────────────────────────────

  // Empty stat container — placeholder until values assigned
  Widget _buildStatContainer() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: 0.5),
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
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Corner flourish with stat container
  Widget _buildCorner({required double rotation}) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        children: [
          Transform.rotate(
            angle: rotation,
            child: SvgPicture.string(
              _cornerSvg,
              width: 72,
              height: 72,
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
          color: Colors.black.withValues(alpha: 0.65),
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

  // Background image — full bleed
  // Shows placeholder colour until real image is available
  Widget _buildBackground() {
    // Check if artwork asset exists — use placeholder if not
    // When real images are ready just drop them in assets/artwork/
    // and this widget will automatically display them
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Placeholder background — replace with Image.asset when ready
            Container(
              color: _placeholderColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      card.isMajorArcana
                          ? card.romanNumeral
                          : card.suit!.symbol,
                      style: TextStyle(
                        fontSize: card.isMajorArcana ? 48 : 64,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Artwork placeholder',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.2),
                        fontStyle: FontStyle.italic,
                      ),
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

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [

          // Layer 1 — full bleed background image / placeholder
          _buildBackground(),

          // Layer 2 — suit frame SVG overlaid on background
          Positioned.fill(
            child: SvgPicture.string(
              _frameSvg,
              fit: BoxFit.fill,
            ),
          ),

          // Layer 3 — corner flourishes with stat containers
          Positioned(
            top: 36,
            left: 0,
            child: _buildCorner(rotation: 0),
          ),
          Positioned(
            top: 36,
            right: 0,
            child: _buildCorner(rotation: math.pi / 2),
          ),
          Positioned(
            bottom: 36,
            left: 0,
            child: _buildCorner(rotation: math.pi * 1.5),
          ),
          Positioned(
            bottom: 36,
            right: 0,
            child: _buildCorner(rotation: math.pi),
          ),

          // Layer 4 — top banner (flipped — reads upside down)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildBanner(card.topBanner, flipped: true),
          ),

          // Layer 5 — bottom banner (card name)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBanner(card.fullName),
          ),

        ],
      ),
    );
  }
}