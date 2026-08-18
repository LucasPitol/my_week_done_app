import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Incrementado quando o app retorna ao foreground — força refresh de prefs nativas.
final appLifecycleRefreshProvider = StateProvider<int>((ref) => 0);
