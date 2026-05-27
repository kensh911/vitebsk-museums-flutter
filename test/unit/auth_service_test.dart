import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitebsk_museums/data/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService sut;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      sut = AuthService(prefs);
    });

    test('isLoggedIn false при старте', () {
      expect(sut.isLoggedIn, false);
    });

    test('currentEmail null при старте', () {
      expect(sut.currentEmail, null);
    });

    test('демо-логин успешен', () async {
      final result = await sut.login('demo@museum.by', 'password123');
      expect(result, true);
    });

    test('isLoggedIn true после логина', () async {
      await sut.login('demo@museum.by', 'password123');
      expect(sut.isLoggedIn, true);
    });

    test('currentEmail возвращает email после логина', () async {
      await sut.login('demo@museum.by', 'password123');
      expect(sut.currentEmail, 'demo@museum.by');
    });

    test('неверный пароль возвращает false', () async {
      final result = await sut.login('demo@museum.by', 'wrongpass');
      expect(result, false);
    });

    test('logout сбрасывает сессию', () async {
      await sut.login('demo@museum.by', 'password123');
      await sut.logout();
      expect(sut.isLoggedIn, false);
    });
  });
}