import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    final isLoggedIn = ref.read(authProvider).isLoggedIn;
    context.go(isLoggedIn ? '/home' : '/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.museum_rounded, size: 80, color: colors.onPrimary),
              const SizedBox(height: 24),
              Text(
                'Музеи Витебска',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 40),
              CircularProgressIndicator(color: colors.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}