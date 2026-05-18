import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class ParentLoginScreen extends StatefulWidget {
  const ParentLoginScreen({super.key});
  @override State<ParentLoginScreen> createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends State<ParentLoginScreen> {
  final _nameCtrl = TextEditingController();
  final _pinCtrl  = TextEditingController();
  bool _isCreate = false, _loading = false, _obscure = true;

  @override void dispose() { _nameCtrl.dispose(); _pinCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final hasParent = app.parent != null;

    return Scaffold(body: Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGrad),
      child: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
        Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context),
            child: Container(width: 42, height: 42,
              decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(13)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18))),
        ]),
        const SizedBox(height: 30),
        Container(width: 90, height: 90,
          decoration: BoxDecoration(gradient: AppColors.blueGrad, shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppColors.blue.withOpacity(0.4), blurRadius: 25)]),
          child: const Center(child: Text('👨‍👩‍👧', style: TextStyle(fontSize: 42)))),
        const SizedBox(height: 20),
        const Text('Parent Dashboard', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900))
          .animate().fadeIn().slideY(begin: 0.3, end: 0),
        const SizedBox(height: 8),
        Text(hasParent && !_isCreate ? 'Enter your PIN to continue' : 'Create your parent account',
          style: const TextStyle(color: AppColors.textG, fontSize: 14)),
        const SizedBox(height: 36),

        if (!hasParent || _isCreate) ...[
          // Name field
          _field(_nameCtrl, 'Your name', Icons.person_rounded, false),
          const SizedBox(height: 14),
        ],

        // PIN field
        _field(_pinCtrl, 'Enter 4-digit PIN', Icons.lock_rounded, _obscure,
          suffix: GestureDetector(onTap: () => setState(() => _obscure = !_obscure),
            child: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textG))),
        const SizedBox(height: 24),

        // Action button
        GestureDetector(
          onTap: _loading ? null : () => _action(app, hasParent),
          child: Container(height: 58, width: double.infinity,
            decoration: BoxDecoration(gradient: AppColors.blueGrad, borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: AppColors.blue.withOpacity(0.4), blurRadius: 20, offset: const Offset(0,6))]),
            child: Center(child: Text(_loading ? 'Please wait...' : (!hasParent || _isCreate ? 'Create Account' : 'Enter Dashboard'),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17))))),

        const SizedBox(height: 16),

        if (hasParent && !_isCreate)
          GestureDetector(onTap: () => setState(() => _isCreate = true),
            child: const Text('Create new parent account →', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w700, fontSize: 13)))
        else if (hasParent)
          GestureDetector(onTap: () => setState(() { _isCreate = false; _nameCtrl.clear(); }),
            child: const Text('← Back to login', style: TextStyle(color: AppColors.textG, fontWeight: FontWeight.w700))),
      ])))));
  }

  Widget _field(TextEditingController ctrl, String hint, IconData icon, bool obscure, {Widget? suffix}) =>
    Container(decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.blue.withOpacity(0.5), width: 2)),
      child: TextField(controller: ctrl, obscureText: obscure,
        keyboardType: hint.contains('PIN') ? TextInputType.number : TextInputType.name,
        maxLength: hint.contains('PIN') ? 4 : null,
        style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
        decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: AppColors.textG),
          border: InputBorder.none, counterText: '',
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          prefixIcon: Icon(icon, color: AppColors.blue), suffixIcon: suffix)));

  Future<void> _action(AppProvider app, bool hasParent) async {
    setState(() => _loading = true);
    if (!hasParent || _isCreate) {
      if (_nameCtrl.text.trim().isEmpty || _pinCtrl.text.length != 4) {
        _err('Please enter your name and a 4-digit PIN');
        setState(() => _loading = false); return;
      }
      await app.createParent(_nameCtrl.text.trim(), _pinCtrl.text);
      if (mounted) Navigator.pushReplacementNamed(context, '/parent');
    } else {
      final ok = await app.loginParent(_pinCtrl.text);
      if (mounted) {
        if (ok) Navigator.pushReplacementNamed(context, '/parent');
        else { _err('Incorrect PIN'); setState(() => _loading = false); }
      }
    }
  }

  void _err(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: AppColors.red, behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
}
