import 'package:flutter/material.dart';

class BlockCategories {
  static const options = [
    (id: 'saude', label: 'Saúde'),
    (id: 'trabalho', label: 'Trabalho'),
    (id: 'estudo', label: 'Estudo'),
    (id: 'lazer', label: 'Lazer'),
  ];

  static String? labelFor(String? id) {
    if (id == null) return null;
    for (final option in options) {
      if (option.id == id) return option.label;
    }
    return null;
  }
}

String formatBlockTime(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

TimeOfDay timeOfDayFromDateTime(DateTime time) {
  return TimeOfDay(hour: time.hour, minute: time.minute);
}

DateTime dateTimeFromTimeOfDay(TimeOfDay time) {
  return DateTime(2000, 1, 1, time.hour, time.minute);
}
