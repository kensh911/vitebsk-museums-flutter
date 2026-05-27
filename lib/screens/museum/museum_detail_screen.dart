import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/extensions/context_ext.dart';
import '../../data/models/models.dart';
import '../../providers/providers.dart';

class MuseumDetailScreen extends ConsumerWidget {
  final String museumId;
  const MuseumDetailScreen({super.key, required this.museumId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final museum = ref.watch(museumByIdProvider(museumId));

    if (museum == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Музей не найден')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            title: Text(museum.name),
            flexibleSpace: FlexibleSpaceBar(
              background: FlutterMap(
                options: MapOptions(
                  initialCenter: museum.location,
                  initialZoom: 15.5,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'by.vitebsk.museums',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: museum.location,
                        child: const Icon(Icons.museum_rounded,
                            color: Colors.blue, size: 32),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    museum.name,
                    style: context.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                      icon: Icons.location_on_outlined,
                      text: museum.address),
                  _InfoRow(
                      icon: Icons.access_time_outlined,
                      text: museum.openHours),
                  _InfoRow(
                      icon: Icons.confirmation_number_outlined,
                      text: museum.admissionFee),
                  const SizedBox(height: 16),
                  Text(museum.description,
                      style: context.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Выставки',
                style: context.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          museum.exhibitions.isEmpty
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Нет запланированных выставок'),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _ExhibitionTile(
                        exhibition: museum.exhibitions[i]),
                    childCount: museum.exhibitions.length,
                  ),
                ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: context.colors.outline),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: context.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _ExhibitionTile extends StatefulWidget {
  final Exhibition exhibition;
  const _ExhibitionTile({required this.exhibition});

  @override
  State<_ExhibitionTile> createState() => _ExhibitionTileState();
}

class _ExhibitionTileState extends State<_ExhibitionTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.15, 0),
        end: Offset.zero,
      ).animate(_anim),
      child: FadeTransition(
        opacity: _anim,
        child: Card(
          margin:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.exhibition.title,
                  style: context.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(widget.exhibition.description,
                    style: context.textTheme.bodySmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 13, color: colors.primary),
                    const SizedBox(width: 4),
                    Text(
                      widget.exhibition.dateRange,
                      style: context.textTheme.labelSmall
                          ?.copyWith(color: colors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}