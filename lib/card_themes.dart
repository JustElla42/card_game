import 'package:flutter/material.dart';

class SuitTheme {
  final Color borderColor;
  final Color backgroundColor;
  final Color suitColor;
  final Color bannerColor;

  const SuitTheme({
    required this.borderColor,
    required this.backgroundColor,
    required this.suitColor,
    required this.bannerColor,
  });
}

SuitTheme getThemeForSuit(String suit) {
  switch (suit) {
    case '\u{1FAA2}':
      return SuitTheme(
        borderColor: Color(0xFFB8960C),
        backgroundColor: Color(0xFFF5E6C8),
        suitColor: Colors.black,
        bannerColor: Color(0xFFB8960C),
      );
    case '*':
      return SuitTheme(
        borderColor: Color(0xFF8B0000),
        backgroundColor: Color(0xFFFFF0F0),
        suitColor: Color(0xFF8B0000),
        bannerColor: Color(0xFF8B0000),
      );
    case '\u{1F534}':
      return SuitTheme(
        borderColor: Color(0xFF1A3A6B),
        backgroundColor: Color(0xFFF0F4FF),
        suitColor: Color(0xFF1A3A6B),
        bannerColor: Color(0xFF1A3A6B),
      );
    case '\u{1F3CF}':
      return SuitTheme(
        borderColor: Color(0xFF1B4D1B),
        backgroundColor: Color(0xFFF0F5F0),
        suitColor: Color(0xFF1B4D1B),
        bannerColor: Color(0xFF1B4D1B),
      );
    default:
      return SuitTheme(
        borderColor: Color(0xFF4A1B8B),
        backgroundColor: Color(0xFF1A1A2E),
        suitColor: Color(0xFFB8960C),
        bannerColor: Color(0xFF4A1B8B),
      );
  }
}