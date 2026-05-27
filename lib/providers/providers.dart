import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/models.dart';
import '../data/repositories/museum_repository.dart';
import '../data/repositories/weather_repository.dart';
import '../data/services/auth_service.dart';
import '../data/services/notification_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in ProviderScope');
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(sharedPreferencesProvider));
});

class AuthState {
  final bool isLoggedIn;
  final String? email;
  const AuthState({required this.isLoggedIn, this.email});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _service;
  AuthNotifier(this._service)
      : super(AuthState(
          isLoggedIn: _service.isLoggedIn,
          email: _service.currentEmail,
        ));

  Future<bool> login(String email, String password) async {
    final ok = await _service.login(email, password);
    if (ok) state = AuthState(isLoggedIn: true, email: email);
    return ok;
  }

  Future<void> logout() async {
    await _service.logout();
    state = const AuthState(isLoggedIn: false);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

final museumRepositoryProvider = Provider<MuseumRepository>((ref) {
  return MuseumRepository();
});

final allDistrictsProvider = Provider<List<District>>((ref) {
  return ref.watch(museumRepositoryProvider).getAllDistricts();
});

final districtByIdProvider =
    Provider.family<District?, String>((ref, id) {
  return ref.watch(museumRepositoryProvider).getDistrictById(id);
});

final museumByIdProvider =
    Provider.family<Museum?, String>((ref, id) {
  return ref.watch(museumRepositoryProvider).getMuseumById(id);
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository();
});

class WeatherState {
  final WeatherData? data;
  final bool isLoading;
  final String? error;
  final bool isFromCache;

  const WeatherState({
    this.data,
    this.isLoading = false,
    this.error,
    this.isFromCache = false,
  });

  WeatherState copyWith({
    WeatherData? data,
    bool? isLoading,
    String? error,
    bool? isFromCache,
  }) =>
      WeatherState(
        data: data ?? this.data,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        isFromCache: isFromCache ?? this.isFromCache,
      );
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherRepository _repo;
  final NotificationService _notifications;

  WeatherNotifier(this._repo, this._notifications)
      : super(const WeatherState());

  Future<void> load(String districtId, double lat, double lon) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repo.getWeather(districtId, lat, lon);
      state = state.copyWith(
        data: data,
        isLoading: false,
        isFromCache: _repo.isCacheStale(data),
      );
      await _notifications.showWeatherNotification(
        'Погода обновлена',
        '${data.currentTemp.round()}°C, ${weatherDescription(data.weatherCode)}',
      );
    } catch (e) {
      print('WeatherNotifier: error — $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Нет подключения к интернету',
        isFromCache: true,
      );
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  return WeatherNotifier(
    ref.watch(weatherRepositoryProvider),
    ref.watch(notificationServiceProvider),
  );
});

class ThemeNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;
  static const _key = 'theme_mode';
  ThemeNotifier(this._prefs) : super(_prefs.getString(_key) ?? 'system');

  Future<void> setMode(String mode) async {
    await _prefs.setString(_key, mode);
    state = mode;
  }
}

final themeProvider =
    StateNotifierProvider<ThemeNotifier, String>((ref) {
  return ThemeNotifier(ref.watch(sharedPreferencesProvider));
});

class LocaleNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;
  static const _key = 'locale';
  LocaleNotifier(this._prefs) : super(_prefs.getString(_key) ?? 'ru');

  Future<void> setLocale(String code) async {
    await _prefs.setString(_key, code);
    state = code;
  }
}

final localeProvider =
    StateNotifierProvider<LocaleNotifier, String>((ref) {
  return LocaleNotifier(ref.watch(sharedPreferencesProvider));
});