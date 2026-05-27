import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../core/extensions/context_ext.dart';

class AdaptiveNav extends StatelessWidget {
  final Widget child;
  const AdaptiveNav({super.key, required this.child});

  static const _destinations = [
    _NavDest(label: 'Главная', icon: Icons.map_outlined, route: '/home'),
    _NavDest(
        label: 'Настройки',
        icon: Icons.settings_outlined,
        route: '/settings'),
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/settings')) return 1;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    context.go(_destinations[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);
    if (context.isWide) {
      return Scaffold(
        body: Shortcuts(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
                const _GoHomeIntent(),
            LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit2):
                const _GoSettingsIntent(),
          },
          child: Actions(
            actions: {
              _GoHomeIntent: CallbackAction<_GoHomeIntent>(
                onInvoke: (_) => context.go('/home'),
              ),
              _GoSettingsIntent: CallbackAction<_GoSettingsIntent>(
                onInvoke: (_) => context.go('/settings'),
              ),
            },
            child: Focus(
              autofocus: true,
              child: Row(
                children: [
                  NavigationRail(
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (i) => _onTap(context, i),
                    labelType: NavigationRailLabelType.all,
                    destinations: _destinations
                        .map((d) => NavigationRailDestination(
                              icon: Icon(d.icon),
                              label: Text(d.label),
                            ))
                        .toList(),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) => _onTap(context, i),
        destinations: _destinations
            .map((d) => NavigationDestination(
                  icon: Icon(d.icon),
                  label: d.label,
                ))
            .toList(),
      ),
    );
  }
}

class _NavDest {
  final String label;
  final IconData icon;
  final String route;
  const _NavDest(
      {required this.label, required this.icon, required this.route});
}

class _GoHomeIntent extends Intent {
  const _GoHomeIntent();
}

class _GoSettingsIntent extends Intent {
  const _GoSettingsIntent();
}