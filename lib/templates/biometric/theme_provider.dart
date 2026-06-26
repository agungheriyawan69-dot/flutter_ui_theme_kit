import 'package:flutter/material.dart';

// ==========================================
// GLOBAL THEME NOTIFIER (SELF-CONTAINED STATE)
// FITUR: Real-time theme switching across all screens
// CARA PAKAI: Akses via BiometricTheme.theme.value
// ==========================================

class BiometricTheme {
  // State global yang bisa didengar (listenable)
  static final ValueNotifier<bool> theme = ValueNotifier<bool>(true); // true = Dark

  static bool get isDark => theme.value;

  static void toggle() {
    theme.value = !theme.value;
  }
}