import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitebsk_museums/providers/providers.dart';
import 'package:vitebsk_museums/screens/auth/login_screen.dart';

Widget _buildApp(SharedPreferences prefs) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const MaterialApp(home: LoginScreen()),
  );
}

void main() {
  group('LoginScreen', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets('отображает поля email и пароль', (tester) async {
      await tester.pumpWidget(_buildApp(prefs));
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
    });

    testWidgets('отображает кнопку входа', (tester) async {
      await tester.pumpWidget(_buildApp(prefs));
      expect(find.byKey(const Key('login_button')), findsOneWidget);
    });

    testWidgets('показывает ошибку при пустых полях', (tester) async {
      await tester.pumpWidget(_buildApp(prefs));
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();
      expect(find.text('Введите email'), findsOneWidget);
    });

    testWidgets('показывает ошибку при неверных данных', (tester) async {
      await tester.pumpWidget(_buildApp(prefs));
      await tester.enterText(
          find.byKey(const Key('email_field')), 'wrong@test.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'wrongpass');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Неверный email или пароль'), findsOneWidget);
    });

    testWidgets('отображает подсказку с демо-данными', (tester) async {
      await tester.pumpWidget(_buildApp(prefs));
      expect(find.textContaining('demo@museum.by'), findsOneWidget);
    });
  });
}