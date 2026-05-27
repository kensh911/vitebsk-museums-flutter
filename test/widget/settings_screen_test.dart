import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitebsk_museums/providers/providers.dart';
import 'package:vitebsk_museums/screens/settings/settings_screen.dart';

Widget _buildApp(SharedPreferences prefs) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const MaterialApp(home: SettingsScreen()),
  );
}

void main() {
  group('SettingsScreen', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets('отображает секцию темы', (tester) async {
      await tester.pumpWidget(_buildApp(prefs));
      expect(find.text('Тема'), findsOneWidget);
    });

    testWidgets('отображает секцию языка', (tester) async {
      await tester.pumpWidget(_buildApp(prefs));
      expect(find.text('Язык интерфейса'), findsOneWidget);
    });

    testWidgets('отображает кнопку очистки кэша', (tester) async {
      await tester.pumpWidget(_buildApp(prefs));
      expect(find.text('Очистить кэш'), findsOneWidget);
    });

    testWidgets('отображает информацию о приложении', (tester) async {
      await tester.pumpWidget(_buildApp(prefs));
      expect(find.text('Лабораторная работа 9'), findsOneWidget);
    });
  });
}