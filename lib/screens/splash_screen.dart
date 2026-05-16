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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _starCtrl;

  @override
  void initState() {
    super.initState();
    _starCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (!mounted) return;
    final user = context.read<UserProvider>();
    Navigator.pushReplacementNamed(context, user.isLoggedIn ? '/home' : '/login');
  }

  @override
  void dispose() {
    _starCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: Stack(
          children: [
            ..._buildStars(size),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo from assets
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.6),
                          blurRadius: 50,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/icon.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.primaryPurple,
                          child: const Center(
                            child: Text('🎓', style: TextStyle(fontSize: 70)),
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0, 0),
                        end: const Offset(1, 1),
                        duration: 700.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: 28),

                  // App name
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFFFD700),
                        Color(0xFFFF69B4),
                        Color(0xFF00BFFF),
                        Color(0xFF7B68EE),
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'QUIZZO',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                  )
                      .animate(delay: 400.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.4, end: 0),

                  const SizedBox(height: 8),

                  // Tagline from logo
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('⭐', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 6),
                        Text(
                          'LEARN  •  PLAY  •  WIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text('⭐', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ).animate(delay: 700.ms).fadeIn(),

                  const SizedBox(height: 70),

                  // Loading dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryPurple,
                          shape: BoxShape.circle,
                        ),
                      )
                          .animate(
                            delay: Duration(milliseconds: 800 + i * 180),
                            onPlay: (c) => c.repeat(reverse: true),
                          )
                          .scaleXY(
                            begin: 0.4,
                            end: 1.6,
                            duration: 600.ms,
                            curve: Curves.easeInOut,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStars(Size s) {
    const positions = [
      [0.08, 0.08], [0.92, 0.12], [0.04, 0.38], [0.96, 0.42],
      [0.12, 0.68], [0.88, 0.72], [0.38, 0.04], [0.62, 0.92],
      [0.25, 0.22], [0.75, 0.55], [0.5, 0.12], [0.18, 0.88],
    ];
    return positions.map((p) {
      return Positioned(
        left: s.width * p[0],
        top: s.height * p[1],
        child: AnimatedBuilder(
          animation: _starCtrl,
          builder: (_, __) => Opacity(
            opacity: (0.2 + 0.8 * (_starCtrl.value + p[0]).remainder(1.0))
                .clamp(0.1, 0.9),
            child: const Text('✨', style: TextStyle(fontSize: 16)),
          ),
        ),
      );
    }).toList();
  }
}
