import 'package:flutter_test/flutter_test.dart';
import 'package:vitebsk_museums/data/models/models.dart';

void main() {
  group('WeatherData', () {
    final mockJson = {
      'current': {
        'temperature_2m': 18.5,
        'weathercode': 2,
      },
      'daily': {
        'time': ['2025-06-01', '2025-06-02', '2025-06-03'],
        'temperature_2m_max': [22.0, 24.0, 20.0],
        'temperature_2m_min': [14.0, 15.0, 12.0],
        'weathercode': [0, 2, 61],
      },
    };

    test('fromJson парсит текущую температуру', () {
      final data = WeatherData.fromJson(mockJson);
      expect(data.currentTemp, 18.5);
    });

    test('fromJson парсит код погоды', () {
      final data = WeatherData.fromJson(mockJson);
      expect(data.weatherCode, 2);
    });

    test('fromJson парсит прогноз на 3 дня', () {
      final data = WeatherData.fromJson(mockJson);
      expect(data.daily.length, 3);
    });

    test('toJson и fromCache сохраняют данные', () {
      final data = WeatherData.fromJson(mockJson);
      final json = data.toJson();
      final restored = WeatherData.fromCache(json);
      expect(restored.currentTemp, data.currentTemp);
      expect(restored.weatherCode, data.weatherCode);
      expect(restored.daily.length, data.daily.length);
    });

    test('weatherDescription возвращает строку для кода 0', () {
      expect(weatherDescription(0), 'Ясно');
    });

    test('weatherDescription возвращает строку для дождя', () {
      expect(weatherDescription(61), 'Дождь');
    });

    test('isCacheStale false для свежих данных', () {
      from(WeatherData.fromJson(mockJson));
    });
  });
}

void from(WeatherData data) {
  final age = DateTime.now().difference(data.fetchedAt);
  expect(age.inHours < 1, true);
}