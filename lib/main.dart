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

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    navigationBarColor: Color(0xFF0F0A1E),
  ));

  runApp(const EduQuestApp());
}

class EduQuestApp extends StatelessWidget {
  const EduQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..init()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: MaterialApp(
        title: 'EduQuest',
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

      case '/shop':
        return _slideRoute(const ShopScreen(), settings);

      case '/parent':
        return _slideRoute(const ParentDashboardScreen(), settings);

      case '/subjects':
        return _slideRoute(const _SubjectsScreen(), settings);

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

      default:
        return _fadeRoute(const HomeScreen(), settings);
    }
  }

  static PageRoute _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRoute _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}

// Auth gate — checks if user is logged in
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoading) {
          return const SplashScreen();
        }
        if (userProvider.isLoggedIn) {
          return const HomeScreen();
        }
        return const SplashScreen();
      },
    );
  }
}

// Simple subjects list screen (navigates to GameSelectScreen)
class _SubjectsScreen extends StatelessWidget {
  const _SubjectsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text('Choose Subject', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              const Expanded(child: HomeScreen()),
            ],
          ),
        ),
      ),
    );
  }
}
