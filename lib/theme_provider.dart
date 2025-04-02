import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<bool>((ref) {
  return false; // Default is light mode, set it to true for dark mode by default
});

void toggleTheme(WidgetRef ref) {
  final currentMode = ref.read(themeProvider);
  ref.read(themeProvider.notifier).state = !currentMode; // Toggle the theme
}
