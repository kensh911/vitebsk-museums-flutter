import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';

class WeatherRepository {
  final Dio _dio;
  static const String _cacheBoxName = 'weather_cache';
  static const String _cacheKey = 'weather_';

  WeatherRepository({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ));

  Future<WeatherData> getWeather(
      String districtId, double lat, double lon) async {
    try {
      final response = await _dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'current': 'temperature_2m,weathercode',
          'daily': 'temperature_2m_max,temperature_2m_min,weathercode',
          'timezone': 'Europe/Minsk',
          'forecast_days': 7,
        },
      );
      final data =
          WeatherData.fromJson(response.data as Map<String, dynamic>);
      await _cacheWeather(districtId, data);
      return data;
    } on DioException catch (e) {
      print('WeatherRepository: network error — ${e.message}');
      final cached = await _getCachedWeather(districtId);
      if (cached != null) return cached;
      rethrow;
    } catch (e) {
      print('WeatherRepository: unexpected error — $e');
      final cached = await _getCachedWeather(districtId);
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<void> _cacheWeather(String districtId, WeatherData data) async {
    try {
      final box = await Hive.openBox(_cacheBoxName);
      await box.put(_cacheKey + districtId, jsonEncode(data.toJson()));
    } catch (e) {
      print('WeatherRepository: cache write error — $e');
    }
  }

  Future<WeatherData?> _getCachedWeather(String districtId) async {
    try {
      final box = await Hive.openBox(_cacheBoxName);
      final raw = box.get(_cacheKey + districtId);
      if (raw == null) return null;
      final json = jsonDecode(raw as String) as Map<String, dynamic>;
      return WeatherData.fromCache(json);
    } catch (e) {
      print('WeatherRepository: cache read error — $e');
      return null;
    }
  }

  Future<void> clearCache() async {
    try {
      final box = await Hive.openBox(_cacheBoxName);
      await box.clear();
    } catch (e) {
      print('WeatherRepository: cache clear error — $e');
    }
  }

  bool isCacheStale(WeatherData data) {
    final age = DateTime.now().difference(data.fetchedAt);
    return age.inHours >= 1;
  }
}