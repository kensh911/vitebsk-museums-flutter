import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'providers/providers.dart';
import 'screens/auth/login_screen.dart';
import 'screens/district/district_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/museum/museum_detail_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'widgets/adaptive_nav.dart';

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => AdaptiveNav(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/district/:id',
      builder: (context, state) =>
          DistrictScreen(districtId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/museum/:id',
      builder: (context, state) =>
          MuseumDetailScreen(museumId: state.pathParameters['id']!),
    ),
  ],
);

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final localeCode = ref.watch(localeProvider);

    ThemeMode mode;
    switch (themeMode) {
      case 'dark':
        mode = ThemeMode.dark;
      case 'light':
        mode = ThemeMode.light;
      default:
        mode = ThemeMode.system;
    }

    return MaterialApp.router(
      key: ValueKey(localeCode),
      title: 'Музеи Витебска',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode,
      routerConfig: _router,
      locale: Locale(localeCode),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
        Locale('be'),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}