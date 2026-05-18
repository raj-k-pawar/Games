import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (!mounted) return;
    final app = context.read<AppProvider>();
    if (app.isChildLoggedIn)       Navigator.pushReplacementNamed(context, '/home');
    else if (app.isParentLoggedIn) Navigator.pushReplacementNamed(context, '/parent');
    else if (app.child != null)    Navigator.pushReplacementNamed(context, '/onboarding');
    else                            Navigator.pushReplacementNamed(context, '/onboarding');
  }

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(body: Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGrad),
      child: Stack(children: [
        ..._stars(size),
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Logo
          Container(width: 160, height: 160,
            decoration: BoxDecoration(shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.7), blurRadius: 60, spreadRadius: 10)]),
            child: ClipOval(child: Image.asset('assets/images/icon.png', fit: BoxFit.cover,
              errorBuilder: (_,__,___) => Container(color: AppColors.primary, child: const Center(child: Text('🎓', style: TextStyle(fontSize: 70)))))),
          ).animate().scale(begin: const Offset(0,0), end: const Offset(1,1), duration: 700.ms, curve: Curves.elasticOut).fadeIn(duration: 400.ms),

          const SizedBox(height: 28),

          // Rainbow QUIZZO text
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(colors: [Color(0xFFFFD700),Color(0xFFFF69B4),Color(0xFF00BFFF),Color(0xFF7B68EE)]).createShader(b),
            child: const Text('QUIZZO', style: TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 5)),
          ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.4, end: 0),

          const SizedBox(height: 10),

          Container(padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Text('⭐', style: TextStyle(fontSize: 14)),
              SizedBox(width: 8),
              Text('LEARN  •  PLAY  •  WIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1.5)),
              SizedBox(width: 8),
              Text('⭐', style: TextStyle(fontSize: 14)),
            ]),
          ).animate(delay: 700.ms).fadeIn(),

          const SizedBox(height: 70),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) =>
            Container(margin: const EdgeInsets.symmetric(horizontal: 5), width: 12, height: 12,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            ).animate(delay: Duration(milliseconds: 800+i*180), onPlay: (c)=>c.repeat(reverse: true))
             .scaleXY(begin: 0.4, end: 1.6, duration: 600.ms)
          )),
        ])),
      ]),
    ));
  }

  List<Widget> _stars(Size s) {
    const pos = [[0.08,0.08],[0.92,0.12],[0.04,0.38],[0.96,0.42],[0.12,0.68],[0.88,0.72],[0.38,0.04],[0.62,0.92],[0.25,0.22],[0.75,0.55]];
    return pos.map((p) => Positioned(left: s.width*p[0], top: s.height*p[1],
      child: AnimatedBuilder(animation: _ctrl, builder: (_,__) =>
        Opacity(opacity: (0.2+0.8*(_ctrl.value+p[0]).remainder(1.0)).clamp(0.1,0.9),
          child: const Text('✨', style: TextStyle(fontSize: 16)))))).toList();
  }
}
