import 'package:flutter/material.dart';

Color categoryColor(String? category, ColorScheme scheme) {
  return switch (category) {
    'saude' => const Color(0xFF2E7D5B),
    'trabalho' => const Color(0xFF3B6FA0),
    'estudo' => const Color(0xFF7B5EA7),
    'lazer' => const Color(0xFFC27C3A),
    _ => scheme.primary,
  };
}
