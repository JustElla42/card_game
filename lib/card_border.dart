import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'card_themes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardBorder extends StatelessWidget {
  final String suit;
  final String title;
  final String topTitle;
  final String topLeft;
  final String topRight;
  final String bottomLeft;
  final String bottomRight;
  final Widget? centerContent;

  const CardBorder({
    super.key,
    required this.suit,
    required this.title,
    required this.topTitle,
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
    this.centerContent,
  });

  static const String _cornerSvgString =
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

  Widget _buildSideSymbols(SuitTheme theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
            (index) => Text(
          '*',
          style: TextStyle(
            fontSize: 11,
            color: theme.borderColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNumberBadge(String number, SuitTheme theme) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.backgroundColor,
        border: Border.all(
          color: theme.borderColor,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: theme.borderColor,
          ),
        ),
      ),
    );
  }

  Widget _buildCornerSvg({
    required double rotation,
    required SuitTheme theme,
    required String number,
  }) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        children: [
          Transform.rotate(
            angle: rotation,
            child: SvgPicture.string(
              _cornerSvgString,
              width: 80,
              height: 80,
              colorFilter: ColorFilter.mode(
                theme.borderColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: _buildNumberBadge(number, theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(String text, SuitTheme theme, {bool flipped = false}) {
    return SizedBox(
      height: 44,
      child: CustomPaint(
        painter: BannerPainter(
          color: theme.bannerColor,
          flipped: flipped,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: flipped ? 8 : 0,
              bottom: flipped ? 0 : 8,
            ),
            child: flipped
                ? Transform.rotate(
              angle: math.pi,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            )
                : Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = getThemeForSuit(suit);

    return Container(
      width: 220,
      height: 340,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.borderColor,
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
                    color: theme.borderColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            // Layer 2 — left side symbols
            Positioned(
              top: 44,
              bottom: 44,
              left: 4,
              child: _buildSideSymbols(theme),
            ),

            // Layer 3 — right side symbols
            Positioned(
              top: 44,
              bottom: 44,
              right: 4,
              child: _buildSideSymbols(theme),
            ),

            // Layer 4 — top left corner
            Positioned(
              top: 36,
              left: 0,
              child: _buildCornerSvg(
                rotation: 0,
                theme: theme,
                number: topLeft,
              ),
            ),

            // Layer 5 — top right corner
            Positioned(
              top: 36,
              right: 0,
              child: _buildCornerSvg(
                rotation: math.pi / 2,
                theme: theme,
                number: topRight,
              ),
            ),

            // Layer 6 — bottom left corner
            Positioned(
              bottom: 36,
              left: 0,
              child: _buildCornerSvg(
                rotation: math.pi * 1.5,
                theme: theme,
                number: bottomLeft,
              ),
            ),

            // Layer 7 — bottom right corner
            Positioned(
              bottom: 36,
              right: 0,
              child: _buildCornerSvg(
                rotation: math.pi,
                theme: theme,
                number: bottomRight,
              ),
            ),

            // Layer 8 — top banner
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildBanner(topTitle, theme, flipped: true),
            ),

            // Layer 9 — bottom banner
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBanner(title, theme),
            ),

            // Layer 10 — center content
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 48, 20, 48),
                child: centerContent ??
                    Center(
                      child: Text(
                        suit,
                        style: TextStyle(
                          fontSize: 80,
                          color: theme.suitColor,
                        ),
                      ),
                    ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

// ─── Banner Painter ───────────────────────────────────────────

class BannerPainter extends CustomPainter {
  final Color color;
  final bool flipped;

  BannerPainter({required this.color, required this.flipped});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    if (!flipped) {
      final path = Path();
      path.moveTo(0, h);
      path.lineTo(0, h * 0.45);
      path.cubicTo(
        w * 0.02, h * 0.45,
        w * 0.04, h * 0.20,
        w * 0.08, h * 0.30,
      );
      path.cubicTo(
        w * 0.10, h * 0.36,
        w * 0.08, h * 0.44,
        w * 0.12, h * 0.40,
      );
      path.cubicTo(
        w * 0.20, h * 0.20,
        w * 0.35, h * 0.05,
        w * 0.50, h * 0.08,
      );
      path.cubicTo(
        w * 0.65, h * 0.05,
        w * 0.80, h * 0.20,
        w * 0.88, h * 0.40,
      );
      path.cubicTo(
        w * 0.92, h * 0.44,
        w * 0.90, h * 0.36,
        w * 0.92, h * 0.30,
      );
      path.cubicTo(
        w * 0.96, h * 0.20,
        w * 0.98, h * 0.45,
        w, h * 0.45,
      );
      path.lineTo(w, h);
      path.close();
      canvas.drawPath(path, paint);
      canvas.drawPath(path, strokePaint);
    } else {
      final path = Path();
      path.moveTo(0, 0);
      path.lineTo(0, h * 0.55);
      path.cubicTo(
        w * 0.02, h * 0.55,
        w * 0.04, h * 0.80,
        w * 0.08, h * 0.70,
      );
      path.cubicTo(
        w * 0.10, h * 0.64,
        w * 0.08, h * 0.56,
        w * 0.12, h * 0.60,
      );
      path.cubicTo(
        w * 0.20, h * 0.80,
        w * 0.35, h * 0.95,
        w * 0.50, h * 0.92,
      );
      path.cubicTo(
        w * 0.65, h * 0.95,
        w * 0.80, h * 0.80,
        w * 0.88, h * 0.60,
      );
      path.cubicTo(
        w * 0.92, h * 0.56,
        w * 0.90, h * 0.64,
        w * 0.92, h * 0.70,
      );
      path.cubicTo(
        w * 0.96, h * 0.80,
        w * 0.98, h * 0.55,
        w, h * 0.55,
      );
      path.lineTo(w, 0);
      path.close();
      canvas.drawPath(path, paint);
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(BannerPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.flipped != flipped;
}