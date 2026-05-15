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
  late AnimationController _starController;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;
    final user = context.read<UserProvider>();
    if (user.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: Stack(
          children: [
            // Floating stars background
            ..._buildStars(),
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C3CE1), Color(0xFF9B59F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.6),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🎓', style: TextStyle(fontSize: 60)),
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0, 0),
                        end: const Offset(1, 1),
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: 24),

                  // App name
                  const Text(
                    'EduQuest',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  )
                      .animate(delay: 300.ms)
                      .slideY(begin: 0.5, end: 0, duration: 500.ms, curve: Curves.easeOut)
                      .fadeIn(),

                  const SizedBox(height: 8),

                  const Text(
                    'Learn. Play. Level Up! 🚀',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textGray,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                      .animate(delay: 500.ms)
                      .fadeIn(duration: 600.ms),

                  const SizedBox(height: 60),

                  // Loading dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryPurple,
                          shape: BoxShape.circle,
                        ),
                      )
                          .animate(
                            delay: Duration(milliseconds: 700 + i * 150),
                            onPlay: (c) => c.repeat(reverse: true),
                          )
                          .scaleXY(
                            begin: 0.5,
                            end: 1.5,
                            duration: 600.ms,
                            curve: Curves.easeInOut,
                          )
                          .then()
                          .scaleXY(begin: 1.5, end: 0.5, duration: 600.ms);
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStars() {
    final positions = [
      [0.1, 0.1], [0.9, 0.15], [0.05, 0.4], [0.95, 0.45],
      [0.15, 0.7], [0.85, 0.75], [0.4, 0.05], [0.6, 0.9],
      [0.3, 0.3], [0.7, 0.6], [0.5, 0.15], [0.2, 0.85],
    ];
    return positions.map((pos) {
      return Positioned(
        left: MediaQuery.of(context).size.width * pos[0],
        top: MediaQuery.of(context).size.height * pos[1],
        child: AnimatedBuilder(
          animation: _starController,
          builder: (context, child) {
            return Opacity(
              opacity: (0.3 + 0.7 * (_starController.value + pos[0]).remainder(1.0)).clamp(0.1, 0.8),
              child: const Text('✨', style: TextStyle(fontSize: 14)),
            );
          },
        ),
      );
    }).toList();
  }
}
