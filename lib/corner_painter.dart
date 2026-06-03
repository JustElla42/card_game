import 'package:flutter/material.dart';
import 'dart:math' as math;

class CornerPainter extends CustomPainter {
  final Color color;
  final double rotation;

  CornerPainter({
    required this.color,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final thinPaint = Paint()
      ..color = color
      ..strokeWidth = 0.9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotation);
    canvas.translate(-size.width / 2, -size.height / 2);

    final w = size.width;
    final h = size.height;

    // ─── Outer vertical arm ──────────────────────────────────
    final vArmOuter = Path();
    vArmOuter.moveTo(w * 0.20, h * 0.98);
    vArmOuter.cubicTo(
      w * 0.20, h * 0.80,
      w * 0.17, h * 0.60,
      w * 0.20, h * 0.38,
    );
    canvas.drawPath(vArmOuter, paint);

    // Inner parallel line on vertical arm
    final vArmInner = Path();
    vArmInner.moveTo(w * 0.28, h * 0.98);
    vArmInner.cubicTo(
      w * 0.28, h * 0.80,
      w * 0.25, h * 0.60,
      w * 0.28, h * 0.40,
    );
    canvas.drawPath(vArmInner, thinPaint);

    // ─── Outer horizontal arm ────────────────────────────────
    final hArmOuter = Path();
    hArmOuter.moveTo(w * 0.98, h * 0.20);
    hArmOuter.cubicTo(
      w * 0.80, h * 0.20,
      w * 0.60, h * 0.17,
      w * 0.38, h * 0.20,
    );
    canvas.drawPath(hArmOuter, paint);

    // Inner parallel line on horizontal arm
    final hArmInner = Path();
    hArmInner.moveTo(w * 0.98, h * 0.28);
    hArmInner.cubicTo(
      w * 0.80, h * 0.28,
      w * 0.60, h * 0.25,
      w * 0.40, h * 0.28,
    );
    canvas.drawPath(hArmInner, thinPaint);

    // ─── Elaborate corner knot ───────────────────────────────
    // Outer sweep from vertical to horizontal
    final knotOuter = Path();
    knotOuter.moveTo(w * 0.20, h * 0.38);
    knotOuter.cubicTo(
      w * 0.20, h * 0.22,
      w * 0.12, h * 0.14,
      w * 0.06, h * 0.08,
    );
    knotOuter.cubicTo(
      w * 0.02, h * 0.04,
      w * 0.04, h * 0.01,
      w * 0.08, h * 0.03,
    );
    knotOuter.cubicTo(
      w * 0.14, h * 0.06,
      w * 0.20, h * 0.12,
      w * 0.28, h * 0.16,
    );
    knotOuter.cubicTo(
      w * 0.34, h * 0.18,
      w * 0.38, h * 0.20,
      w * 0.38, h * 0.20,
    );
    canvas.drawPath(knotOuter, paint);

    // Inner loop of the knot — creates the interlocking effect
    final knotInner = Path();
    knotInner.moveTo(w * 0.20, h * 0.30);
    knotInner.cubicTo(
      w * 0.22, h * 0.22,
      w * 0.28, h * 0.18,
      w * 0.32, h * 0.22,
    );
    knotInner.cubicTo(
      w * 0.36, h * 0.26,
      w * 0.30, h * 0.34,
      w * 0.22, h * 0.30,
    );
    knotInner.cubicTo(
      w * 0.16, h * 0.26,
      w * 0.14, h * 0.18,
      w * 0.18, h * 0.14,
    );
    knotInner.cubicTo(
      w * 0.22, h * 0.10,
      w * 0.28, h * 0.12,
      w * 0.26, h * 0.18,
    );
    canvas.drawPath(knotInner, thinPaint);

    // Second inner loop — adds complexity
    final knotLoop = Path();
    knotLoop.moveTo(w * 0.10, h * 0.18);
    knotLoop.cubicTo(
      w * 0.08, h * 0.12,
      w * 0.12, h * 0.08,
      w * 0.18, h * 0.10,
    );
    knotLoop.cubicTo(
      w * 0.24, h * 0.12,
      w * 0.26, h * 0.20,
      w * 0.20, h * 0.24,
    );
    knotLoop.cubicTo(
      w * 0.14, h * 0.28,
      w * 0.08, h * 0.24,
      w * 0.10, h * 0.18,
    );
    canvas.drawPath(knotLoop, thinPaint);

    // ─── Vertical arm scrolls ────────────────────────────────
    // Large upper scroll
    final vScroll1 = Path();
    vScroll1.moveTo(w * 0.20, h * 0.56);
    vScroll1.cubicTo(
      w * 0.34, h * 0.54,
      w * 0.42, h * 0.44,
      w * 0.34, h * 0.40,
    );
    vScroll1.cubicTo(
      w * 0.26, h * 0.36,
      w * 0.14, h * 0.40,
      w * 0.16, h * 0.50,
    );
    vScroll1.cubicTo(
      w * 0.17, h * 0.56,
      w * 0.22, h * 0.58,
      w * 0.26, h * 0.54,
    );
    canvas.drawPath(vScroll1, paint);

    // Small inner curl on upper scroll
    final vScroll1Inner = Path();
    vScroll1Inner.moveTo(w * 0.26, h * 0.54);
    vScroll1Inner.cubicTo(
      w * 0.30, h * 0.50,
      w * 0.28, h * 0.44,
      w * 0.22, h * 0.46,
    );
    canvas.drawPath(vScroll1Inner, thinPaint);

    // Large lower scroll
    final vScroll2 = Path();
    vScroll2.moveTo(w * 0.20, h * 0.76);
    vScroll2.cubicTo(
      w * 0.34, h * 0.74,
      w * 0.40, h * 0.64,
      w * 0.32, h * 0.61,
    );
    vScroll2.cubicTo(
      w * 0.24, h * 0.58,
      w * 0.14, h * 0.62,
      w * 0.16, h * 0.71,
    );
    vScroll2.cubicTo(
      w * 0.17, h * 0.76,
      w * 0.22, h * 0.78,
      w * 0.26, h * 0.74,
    );
    canvas.drawPath(vScroll2, paint);

    // Small inner curl on lower scroll
    final vScroll2Inner = Path();
    vScroll2Inner.moveTo(w * 0.26, h * 0.74);
    vScroll2Inner.cubicTo(
      w * 0.30, h * 0.70,
      w * 0.28, h * 0.64,
      w * 0.22, h * 0.66,
    );
    canvas.drawPath(vScroll2Inner, thinPaint);

    // ─── Horizontal arm scrolls ──────────────────────────────
    // Large left scroll
    final hScroll1 = Path();
    hScroll1.moveTo(w * 0.56, h * 0.20);
    hScroll1.cubicTo(
      w * 0.54, h * 0.34,
      w * 0.44, h * 0.42,
      w * 0.40, h * 0.34,
    );
    hScroll1.cubicTo(
      w * 0.36, h * 0.26,
      w * 0.40, h * 0.14,
      w * 0.50, h * 0.16,
    );
    hScroll1.cubicTo(
      w * 0.56, h * 0.17,
      w * 0.58, h * 0.22,
      w * 0.54, h * 0.26,
    );
    canvas.drawPath(hScroll1, paint);

    // Small inner curl on left scroll
    final hScroll1Inner = Path();
    hScroll1Inner.moveTo(w * 0.54, h * 0.26);
    hScroll1Inner.cubicTo(
      w * 0.50, h * 0.30,
      w * 0.44, h * 0.28,
      w * 0.46, h * 0.22,
    );
    canvas.drawPath(hScroll1Inner, thinPaint);

    // Large right scroll
    final hScroll2 = Path();
    hScroll2.moveTo(w * 0.76, h * 0.20);
    hScroll2.cubicTo(
      w * 0.74, h * 0.34,
      w * 0.64, h * 0.40,
      w * 0.61, h * 0.32,
    );
    hScroll2.cubicTo(
      w * 0.58, h * 0.24,
      w * 0.62, h * 0.14,
      w * 0.71, h * 0.16,
    );
    hScroll2.cubicTo(
      w * 0.76, h * 0.17,
      w * 0.78, h * 0.22,
      w * 0.74, h * 0.26,
    );
    canvas.drawPath(hScroll2, paint);

    // Small inner curl on right scroll
    final hScroll2Inner = Path();
    hScroll2Inner.moveTo(w * 0.74, h * 0.26);
    hScroll2Inner.cubicTo(
      w * 0.70, h * 0.30,
      w * 0.64, h * 0.28,
      w * 0.66, h * 0.22,
    );
    canvas.drawPath(hScroll2Inner, thinPaint);

    // ─── Teardrop accents between scrolls ───────────────────
    // On vertical arm between scrolls
    final vTear = Path();
    vTear.moveTo(w * 0.20, h * 0.66);
    vTear.cubicTo(
      w * 0.24, h * 0.64,
      w * 0.26, h * 0.67,
      w * 0.24, h * 0.70,
    );
    vTear.cubicTo(
      w * 0.22, h * 0.73,
      w * 0.18, h * 0.71,
      w * 0.20, h * 0.66,
    );
    canvas.drawPath(vTear, paint);

    // On horizontal arm between scrolls
    final hTear = Path();
    hTear.moveTo(w * 0.66, h * 0.20);
    hTear.cubicTo(
      w * 0.64, h * 0.24,
      w * 0.67, h * 0.26,
      w * 0.70, h * 0.24,
    );
    hTear.cubicTo(
      w * 0.73, h * 0.22,
      w * 0.71, h * 0.18,
      w * 0.66, h * 0.20,
    );
    canvas.drawPath(hTear, paint);

    // ─── Dot accents ─────────────────────────────────────────
    canvas.drawCircle(Offset(w * 0.20, h * 0.98), 2.5, fillPaint);
    canvas.drawCircle(Offset(w * 0.98, h * 0.20), 2.5, fillPaint);
    canvas.drawCircle(Offset(w * 0.34, h * 0.40), 1.8, fillPaint);
    canvas.drawCircle(Offset(w * 0.32, h * 0.61), 1.8, fillPaint);
    canvas.drawCircle(Offset(w * 0.40, h * 0.34), 1.8, fillPaint);
    canvas.drawCircle(Offset(w * 0.61, h * 0.32), 1.8, fillPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CornerPainter oldDelegate) =>
      oldDelegate.color != color ||
          oldDelegate.rotation != rotation;
}