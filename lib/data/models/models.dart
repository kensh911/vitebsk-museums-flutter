import 'package:latlong2/latlong.dart';

class Exhibition {
  final String id;
  final String title;
  final String description;
  final String dateRange;

  const Exhibition({
    required this.id,
    required this.title,
    required this.description,
    required this.dateRange,
  });

  factory Exhibition.fromJson(Map<String, dynamic> json) => Exhibition(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        dateRange: json['dateRange'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dateRange': dateRange,
      };
}

class Museum {
  final String id;
  final String name;
  final String description;
  final String address;
  final String openHours;
  final String admissionFee;
  final LatLng location;
  final List<Exhibition> exhibitions;
  final String districtId;

  const Museum({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.openHours,
    required this.admissionFee,
    required this.location,
    required this.exhibitions,
    required this.districtId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'address': address,
        'openHours': openHours,
        'admissionFee': admissionFee,
        'lat': location.latitude,
        'lon': location.longitude,
        'exhibitions': exhibitions.map((e) => e.toJson()).toList(),
        'districtId': districtId,
      };
}

class District {
  final String id;
  final String nameRu;
  final String nameEn;
  final String nameBe;
  final LatLng center;
  final List<Museum> museums;

  const District({
    required this.id,
    required this.nameRu,
    required this.nameEn,
    required this.nameBe,
    required this.center,
    required this.museums,
  });
}

class WeatherData {
  final double currentTemp;
  final int weatherCode;
  final List<DailyForecast> daily;
  final DateTime fetchedAt;

  const WeatherData({
    required this.currentTemp,
    required this.weatherCode,
    required this.daily,
    required this.fetchedAt,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;
    final dates = daily['time'] as List<dynamic>;
    final maxTemps = daily['temperature_2m_max'] as List<dynamic>;
    final minTemps = daily['temperature_2m_min'] as List<dynamic>;
    final codes = daily['weathercode'] as List<dynamic>;

    return WeatherData(
      currentTemp: (current['temperature_2m'] as num).toDouble(),
      weatherCode: current['weathercode'] as int,
      daily: List.generate(
        dates.length,
        (i) => DailyForecast(
          date: dates[i] as String,
          maxTemp: (maxTemps[i] as num).toDouble(),
          minTemp: (minTemps[i] as num).toDouble(),
          weatherCode: codes[i] as int,
        ),
      ),
      fetchedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'currentTemp': currentTemp,
        'weatherCode': weatherCode,
        'daily': daily.map((d) => d.toJson()).toList(),
        'fetchedAt': fetchedAt.toIso8601String(),
      };

  factory WeatherData.fromCache(Map<String, dynamic> json) => WeatherData(
        currentTemp: (json['currentTemp'] as num).toDouble(),
        weatherCode: json['weatherCode'] as int,
        daily: (json['daily'] as List<dynamic>)
            .map((d) => DailyForecast.fromJson(d as Map<String, dynamic>))
            .toList(),
        fetchedAt: DateTime.parse(json['fetchedAt'] as String),
      );
}

class DailyForecast {
  final String date;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;

  const DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) => DailyForecast(
        date: json['date'] as String,
        maxTemp: (json['maxTemp'] as num).toDouble(),
        minTemp: (json['minTemp'] as num).toDouble(),
        weatherCode: json['weatherCode'] as int,
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'maxTemp': maxTemp,
        'minTemp': minTemp,
        'weatherCode': weatherCode,
      };
}

String weatherDescription(int code) {
  if (code == 0) return 'Ясно';
  if (code <= 3) return 'Облачно';
  if (code <= 48) return 'Туман';
  if (code <= 55) return 'Морось';
  if (code <= 65) return 'Дождь';
  if (code <= 75) return 'Снег';
  if (code <= 82) return 'Ливень';
  if (code <= 86) return 'Снегопад';
  return 'Гроза';
}

String weatherIcon(int code) {
  if (code == 0) return '☀️';
  if (code <= 3) return '⛅';
  if (code <= 48) return '🌫️';
  if (code <= 55) return '🌦️';
  if (code <= 65) return '🌧️';
  if (code <= 75) return '❄️';
  if (code <= 82) return '⛈️';
  if (code <= 86) return '🌨️';
  return '⛈️';
}