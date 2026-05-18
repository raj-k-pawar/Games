import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Container(
    decoration: const BoxDecoration(gradient: AppColors.bgGrad),
    child: const SafeArea(child: Center(child: Text('Profile Screen', style: TextStyle(color: Colors.white))))));
}
