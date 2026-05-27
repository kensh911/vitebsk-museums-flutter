import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../core/extensions/context_ext.dart';
import '../../providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final districts = ref.watch(allDistrictsProvider);
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Музеи Витебска'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                'Добро пожаловать, ${auth.email ?? ''}',
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: context.colors.outline),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 240,
                  child: FlutterMap(
                    options: const MapOptions(
                      initialCenter: LatLng(55.193, 30.201),
                      initialZoom: 12.5,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'by.vitebsk.museums',
                      ),
                      MarkerLayer(
                        markers: districts
                            .expand((d) => d.museums)
                            .map((m) => Marker(
                                  point: m.location,
                                  width: 36,
                                  height: 36,
                                  child: GestureDetector(
                                    onTap: () =>
                                        context.push('/museum/${m.id}'),
                                    child: const Icon(
                                      Icons.museum_rounded,
                                      color: Colors.blue,
                                      size: 28,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Музеев по районам',
                style: context.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 5,
                    barGroups: List.generate(districts.length, (i) {
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: districts[i].museums.length.toDouble(),
                            color: context.colors.primary,
                            width: 28,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                        ],
                      );
                    }),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i >= districts.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                districts[i].nameRu.split(' ').first,
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Районы города',
                style: context.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 4)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final d = districts[i];
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => context.push('/district/${d.id}'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                context.colors.primaryContainer,
                            child: Icon(Icons.location_city,
                                color: context.colors.primary),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  d.nameRu,
                                  style: context.textTheme.titleSmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${d.museums.length} ${_museumWord(d.museums.length)}',
                                  style: context.textTheme.bodySmall
                                      ?.copyWith(
                                          color: context.colors.outline),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: districts.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  String _museumWord(int n) {
    if (n == 1) return 'музей';
    if (n <= 4) return 'музея';
    return 'музеев';
  }
}