import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          _SectionHeader('Оформление'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Тема'),
            trailing: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'light', label: Text('Светлая')),
                ButtonSegment(value: 'system', label: Text('Авто')),
                ButtonSegment(value: 'dark', label: Text('Тёмная')),
              ],
              selected: {themeMode},
              onSelectionChanged: (v) =>
                  ref.read(themeProvider.notifier).setMode(v.first),
            ),
          ),
          _SectionHeader('Язык'),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('Язык интерфейса'),
            trailing: DropdownButton<String>(
              value: locale,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: 'ru', child: Text('Русский')),
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'be', child: Text('Беларуская')),
              ],
              onChanged: (v) {
                if (v != null) {
                  ref.read(localeProvider.notifier).setLocale(v);
                }
              },
            ),
          ),
          _SectionHeader('Данные'),
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined),
            title: const Text('Очистить кэш'),
            subtitle: const Text('Удалить сохранённые данные о погоде'),
            onTap: () async {
              await ref.read(weatherRepositoryProvider).clearCache();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Кэш очищен')),
                );
              }
            },
          ),
          _SectionHeader('О приложении'),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.data?.version ?? '...';
              final build = snapshot.data?.buildNumber ?? '';
              return ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Версия'),
                subtitle: Text('$version ($build)'),
              );
            },
          ),
          const ListTile(
            leading: Icon(Icons.school_outlined),
            title: Text('Лабораторная работа 9'),
            subtitle: Text('БГУ ФПМИ, 2026–2027'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}