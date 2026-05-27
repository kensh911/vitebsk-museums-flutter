import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/extensions/context_ext.dart';
import '../../data/models/models.dart';
import '../../providers/providers.dart';

class DistrictScreen extends ConsumerStatefulWidget {
  final String districtId;
  const DistrictScreen({super.key, required this.districtId});

  @override
  ConsumerState<DistrictScreen> createState() => _DistrictScreenState();
}

class _DistrictScreenState extends ConsumerState<DistrictScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final district =
          ref.read(districtByIdProvider(widget.districtId));
      if (district != null) {
        ref.read(weatherProvider.notifier).load(
              district.id,
              district.center.latitude,
              district.center.longitude,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final district =
        ref.watch(districtByIdProvider(widget.districtId));
    final weather = ref.watch(weatherProvider);

    if (district == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Район не найден')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(district.nameRu)),
      body: CustomScrollView(
        slivers: [
          if (weather.isFromCache)
            SliverToBoxAdapter(
              child: MaterialBanner(
                content:
                    const Text('Офлайн-режим — кэшированные данные'),
                leading: const Icon(Icons.cloud_off),
                actions: [
                  TextButton(
                    onPressed: () =>
                        ref.read(weatherProvider.notifier).load(
                              district.id,
                              district.center.latitude,
                              district.center.longitude,
                            ),
                    child: const Text('Обновить'),
                  ),
                ],
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _WeatherCard(weather: weather),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text(
                'Музеи района',
                style: context.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final museum = district.museums[i];
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () =>
                        context.push('/museum/${museum.id}'),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  museum.name,
                                  style: context.textTheme.titleSmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 14,
                                  color: context.colors.outline),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  museum.address,
                                  style: context.textTheme.bodySmall
                                      ?.copyWith(
                                          color: context.colors.outline),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.access_time_outlined,
                                  size: 14,
                                  color: context.colors.outline),
                              const SizedBox(width: 4),
                              Text(
                                museum.openHours,
                                style: context.textTheme.bodySmall
                                    ?.copyWith(
                                        color: context.colors.outline),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Chip(
                            label: Text(
                              '${museum.exhibitions.length} выставки',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: context
                                      .colors.onPrimaryContainer),
                            ),
                            backgroundColor:
                                context.colors.primaryContainer,
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: district.museums.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final WeatherState weather;
  const _WeatherCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (weather.isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (weather.error != null && weather.data == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(weather.error!,
              style: TextStyle(color: colors.error)),
        ),
      );
    }
    final data = weather.data;
    if (data == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(weatherIcon(data.weatherCode),
                    style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data.currentTemp.round()}°C',
                      style: context.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      weatherDescription(data.weatherCode),
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: colors.outline),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Прогноз на неделю',
                style: context.textTheme.labelLarge),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: data.daily
                    .take(7)
                    .map((d) => _DayForecast(day: d))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayForecast extends StatelessWidget {
  final DailyForecast day;
  const _DayForecast({required this.day});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final date = day.date.length >= 7 ? day.date.substring(5) : day.date;
    return Container(
      width: 64,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(date, style: const TextStyle(fontSize: 11)),
          const SizedBox(height: 4),
          Text(weatherIcon(day.weatherCode)),
          Text('${day.maxTemp.round()}°',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12)),
          Text('${day.minTemp.round()}°',
              style:
                  TextStyle(color: colors.outline, fontSize: 11)),
        ],
      ),
    );
  }
}