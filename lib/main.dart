import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/game_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/game_select_screen.dart';
import 'screens/game_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/parent_dashboard_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const KidzoLandApp());
}

class KidzoLandApp extends StatelessWidget {
  const KidzoLandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..init()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: MaterialApp(
        title: 'KidzoLand',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: '/',
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _fadeRoute(const _AuthGate(), settings);
      case '/login':
        return _slideRoute(const LoginScreen(), settings);
      case '/home':
        return _fadeRoute(const HomeScreen(), settings);
      case '/game_select':
        final subjectId = settings.arguments as String? ?? 'mathematics';
        return _slideRoute(GameSelectScreen(subjectId: subjectId), settings);
      case '/game':
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _slideRoute(
          GameScreen(
            subjectId: args['subjectId'] ?? 'mathematics',
            gameMode: args['gameMode'] ?? 'quick_calc',
            difficulty: args['difficulty'] ?? 'easy',
          ),
          settings,
        );
      case '/shop':
        return _slideRoute(const ShopScreen(), settings);
      case '/parent':
        return _slideRoute(const ParentDashboardScreen(), settings);
      default:
        return _fadeRoute(const HomeScreen(), settings);
    }
  }

  static PageRoute _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRoute _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoading) return const SplashScreen();
        if (userProvider.isLoggedIn) return const HomeScreen();
        return const SplashScreen();
      },
    );
  }
}
