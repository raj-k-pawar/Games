import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _starCtrl;

  @override
  void initState() {
    super.initState();
    _starCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;
    final user = context.read<UserProvider>();
    Navigator.pushReplacementNamed(context, user.isLoggedIn ? '/home' : '/login');
  }

  @override
  void dispose() { _starCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: Stack(
          children: [
            ..._stars(context),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      gradient: AppColors.purpleGradient,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [BoxShadow(color: AppColors.primaryPurple.withOpacity(0.6), blurRadius: 40, spreadRadius: 5)],
                    ),
                    child: const Center(child: Text('🎓', style: TextStyle(fontSize: 60))),
                  ).animate().scale(begin: const Offset(0,0), end: const Offset(1,1), duration: 600.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 24),
                  const Text('KidzoLand', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1))
                      .animate(delay: 300.ms).slideY(begin: 0.5, end: 0, duration: 500.ms).fadeIn(),
                  const SizedBox(height: 8),
                  const Text('Learn. Play. Level Up! 🚀', style: TextStyle(fontSize: 16, color: AppColors.textGray, fontWeight: FontWeight.w600))
                      .animate(delay: 500.ms).fadeIn(),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 10, height: 10,
                      decoration: const BoxDecoration(color: AppColors.primaryPurple, shape: BoxShape.circle),
                    ).animate(delay: Duration(milliseconds: 700 + i * 150), onPlay: (c) => c.repeat(reverse: true))
                     .scaleXY(begin: 0.5, end: 1.5, duration: 600.ms, curve: Curves.easeInOut)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _stars(BuildContext ctx) {
    final s = MediaQuery.of(ctx).size;
    final positions = [[0.1,0.1],[0.9,0.15],[0.05,0.4],[0.95,0.45],[0.15,0.7],[0.85,0.75],[0.4,0.05],[0.6,0.9]];
    return positions.map((p) => Positioned(
      left: s.width * p[0], top: s.height * p[1],
      child: AnimatedBuilder(animation: _starCtrl, builder: (_, __) => Opacity(
        opacity: (0.3 + 0.7 * (_starCtrl.value + p[0]).remainder(1.0)).clamp(0.1, 0.8),
        child: const Text('✨', style: TextStyle(fontSize: 14)),
      )),
    )).toList();
  }
}
