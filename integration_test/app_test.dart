import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vitebsk_museums/app.dart';
import 'package:vitebsk_museums/providers/providers.dart';
import 'package:vitebsk_museums/screens/auth/login_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration: Auth Flow', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await Hive.initFlutter();
    });

    testWidgets('приложение запускается и показывает splash', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const App(),
        ),
      );
      await tester.pump();
      expect(find.text('Музеи Витебска'), findsWidgets);
    });

    testWidgets('неавторизованный пользователь попадает на логин',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('успешный вход переходит на главную', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.enterText(
          find.byKey(const Key('email_field')), 'demo@museum.by');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'password123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text('Районы города'), findsOneWidget);
    });
  });
}