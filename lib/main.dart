import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';
import 'providers/app_provider.dart';
import 'providers/game_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/child_home_screen.dart';
import 'screens/game_select_screen.dart';
import 'screens/game_screen.dart';
import 'screens/result_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/parent_login_screen.dart';
import 'screens/parent_dashboard_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/challenge_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const QuizzoApp());
}

class QuizzoApp extends StatelessWidget {
  const QuizzoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()..init()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: MaterialApp(
        title: 'Quizzo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: '/',
        onGenerateRoute: _routes,
      ),
    );
  }

  Route<dynamic>? _routes(RouteSettings s) {
    switch (s.name) {
      case '/':           return _fade(const _AuthGate(), s);
      case '/onboarding': return _slide(const OnboardingScreen(), s);
      case '/home':       return _fade(const ChildHomeScreen(), s);
      case '/game_select':
        final sub = s.arguments as String? ?? 'mathematics';
        return _slide(GameSelectScreen(subjectId: sub), s);
      case '/game':
        final args = s.arguments as Map<String,dynamic>? ?? {};
        return _slide(GameScreen(subjectId: args['subjectId']??'mathematics', difficulty: args['difficulty']??'easy', count: args['count']??25), s);
      case '/result':
        final r = s.arguments as GameResult?;
        return _fade(ResultScreen(result: r), s);
      case '/shop':           return _slide(const ShopScreen(), s);
      case '/parent_login':   return _slide(const ParentLoginScreen(), s);
      case '/parent':         return _slide(const ParentDashboardScreen(), s);
      case '/leaderboard':    return _slide(const LeaderboardScreen(), s);
      case '/profile':        return _slide(const ProfileScreen(), s);
      case '/challenge':      return _slide(const ChallengeScreen(), s);
      default:                return _fade(const ChildHomeScreen(), s);
    }
  }

  static PageRoute _fade(Widget w, RouteSettings s) => PageRouteBuilder(
    settings: s, pageBuilder: (_,__,___) => w,
    transitionsBuilder: (_,a,__,c) => FadeTransition(opacity: a, child: c),
    transitionDuration: const Duration(milliseconds: 300),
  );
  static PageRoute _slide(Widget w, RouteSettings s) => PageRouteBuilder(
    settings: s, pageBuilder: (_,__,___) => w,
    transitionsBuilder: (_,a,__,c) {
      final t = Tween(begin: const Offset(1,0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(position: a.drive(t), child: c);
    },
    transitionDuration: const Duration(milliseconds: 350),
  );
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (ctx, app, _) {
      if (app.isLoading) return const SplashScreen();
      if (app.isChildLoggedIn) return const ChildHomeScreen();
      if (app.isParentLoggedIn) return const ParentDashboardScreen();
      return const SplashScreen();
    });
  }
}
