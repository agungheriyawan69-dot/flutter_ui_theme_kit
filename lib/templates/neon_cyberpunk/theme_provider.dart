import 'package:flutter/material.dart';

class NeonCyberpunkTheme {
  static final ValueNotifier<bool> theme = ValueNotifier<bool>(true); // Default Dark
  static bool get isDark => theme.value;
  static void toggle() => theme.value = !theme.value;
}