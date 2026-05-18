import 'package:flutter/material.dart';

class AppColors {
  static const Color primary    = Color(0xFF6C3CE1);
  static const Color primaryL   = Color(0xFF9B59F5);
  static const Color blue       = Color(0xFF3B82F6);
  static const Color pink       = Color(0xFFEC4899);
  static const Color orange     = Color(0xFFF97316);
  static const Color green      = Color(0xFF22C55E);
  static const Color yellow     = Color(0xFFFBBF24);
  static const Color red        = Color(0xFFEF4444);
  static const Color cyan       = Color(0xFF06B6D4);
  static const Color bgDark     = Color(0xFF0F0A1E);
  static const Color bgCard     = Color(0xFF1A1035);
  static const Color bgCardL    = Color(0xFF241848);
  static const Color textW      = Color(0xFFFFFFFF);
  static const Color textG      = Color(0xFFAA9FCC);
  static const Color textL      = Color(0xFFD4CAFE);

  static const LinearGradient purpleGrad = LinearGradient(colors:[Color(0xFF6C3CE1),Color(0xFF9B59F5)],begin:Alignment.topLeft,end:Alignment.bottomRight);
  static const LinearGradient blueGrad   = LinearGradient(colors:[Color(0xFF1D4ED8),Color(0xFF3B82F6)],begin:Alignment.topLeft,end:Alignment.bottomRight);
  static const LinearGradient pinkGrad   = LinearGradient(colors:[Color(0xFFBE185D),Color(0xFFEC4899)],begin:Alignment.topLeft,end:Alignment.bottomRight);
  static const LinearGradient orangeGrad = LinearGradient(colors:[Color(0xFFEA580C),Color(0xFFF97316)],begin:Alignment.topLeft,end:Alignment.bottomRight);
  static const LinearGradient greenGrad  = LinearGradient(colors:[Color(0xFF16A34A),Color(0xFF22C55E)],begin:Alignment.topLeft,end:Alignment.bottomRight);
  static const LinearGradient cyanGrad   = LinearGradient(colors:[Color(0xFF0891B2),Color(0xFF06B6D4)],begin:Alignment.topLeft,end:Alignment.bottomRight);
  static const LinearGradient bgGrad     = LinearGradient(colors:[Color(0xFF0F0A1E),Color(0xFF1A0F3A)],begin:Alignment.topCenter,end:Alignment.bottomCenter);
  static const LinearGradient goldGrad   = LinearGradient(colors:[Color(0xFFB45309),Color(0xFFFBBF24)],begin:Alignment.topLeft,end:Alignment.bottomRight);

  static final List<LinearGradient> subjectGrads = [
    blueGrad, greenGrad, orangeGrad, purpleGrad,
    cyanGrad, goldGrad, pinkGrad, LinearGradient(colors:[Color(0xFF059669),Color(0xFF10B981)],begin:Alignment.topLeft,end:Alignment.bottomRight),
  ];
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgDark,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.dark(primary: AppColors.primary, secondary: AppColors.blue, surface: AppColors.bgCard),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color:AppColors.textW,fontWeight:FontWeight.w900),
      headlineLarge: TextStyle(color:AppColors.textW,fontWeight:FontWeight.w800),
      titleLarge: TextStyle(color:AppColors.textW,fontWeight:FontWeight.w700),
      bodyLarge: TextStyle(color:AppColors.textW),
      bodyMedium: TextStyle(color:AppColors.textL),
      bodySmall: TextStyle(color:AppColors.textG),
    ),
  );
}

class AppDeco {
  static BoxDecoration card({Color? color, List<Color>? grad, double r=18, bool glow=false, Color glowColor=AppColors.primary}) =>
    BoxDecoration(
      color: grad==null?(color??AppColors.bgCard):null,
      gradient: grad!=null?LinearGradient(colors:grad,begin:Alignment.topLeft,end:Alignment.bottomRight):null,
      borderRadius: BorderRadius.circular(r),
      boxShadow: glow
        ?[BoxShadow(color:glowColor.withOpacity(0.4),blurRadius:20,spreadRadius:2)]
        :[BoxShadow(color:Colors.black.withOpacity(0.3),blurRadius:10,offset:Offset(0,4))],
      border: Border.all(color:(grad?.first??color??AppColors.primary).withOpacity(0.3),width:1.5),
    );
}
