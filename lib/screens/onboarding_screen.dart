import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameCtrl = TextEditingController();
  String _avatarId = 'avatar_fox';
  bool _loading = false;
  int _step = 0; // 0=choose role, 1=child name, 2=child avatar

  static const _avatars = [
    {'id':'avatar_fox','emoji':'🦊','name':'Fox'},{'id':'avatar_panda','emoji':'🐼','name':'Panda'},
    {'id':'avatar_lion','emoji':'🦁','name':'Lion'},{'id':'avatar_frog','emoji':'🐸','name':'Frog'},
    {'id':'avatar_tiger','emoji':'🐯','name':'Tiger'},{'id':'avatar_unicorn','emoji':'🦄','name':'Unicorn'},
    {'id':'avatar_wolf','emoji':'🐺','name':'Wolf'},{'id':'avatar_dragon','emoji':'🐉','name':'Dragon'},
    {'id':'avatar_eagle','emoji':'🦅','name':'Eagle'},{'id':'avatar_bear','emoji':'🐻','name':'Bear'},
    {'id':'avatar_dolphin','emoji':'🐬','name':'Dolphin'},{'id':'avatar_cat','emoji':'🐱','name':'Cat'},
  ];

  @override void dispose() { _nameCtrl.dispose(); super.dispose(); }

  Widget _btn(String label, VoidCallback? onTap, LinearGradient grad) => GestureDetector(
    onTap: onTap,
    child: Container(height: 58, width: double.infinity,
      decoration: BoxDecoration(gradient: onTap!=null?grad:null, color: onTap==null?AppColors.bgCardL:null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: onTap!=null?[BoxShadow(color: grad.colors.first.withOpacity(0.4), blurRadius: 20, offset: const Offset(0,6))]:null),
      child: Center(child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGrad),
      child: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
        const SizedBox(height: 16),
        // Logo
        ClipOval(child: Image.asset('assets/images/icon.png', width: 90, height: 90, fit: BoxFit.cover,
          errorBuilder: (_,__,___) => const Text('🎓', style: TextStyle(fontSize: 64)))),
        const SizedBox(height: 16),

        if (_step == 0) ...[
          const Text('Welcome to Quizzo! 🎉', textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900))
              .animate().fadeIn().slideY(begin: 0.3, end: 0),
          const SizedBox(height: 8),
          const Text('Learn, Play & Win Amazing Rewards!', textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textG, fontSize: 15)),
          const SizedBox(height: 40),

          // Child card
          _RoleCard(emoji: '🎮', title: "I'm a Child", subtitle: 'Play games & earn rewards', color: AppColors.primary,
            onTap: () => setState(() => _step = 1)),
          const SizedBox(height: 14),

          // Parent card
          _RoleCard(emoji: '👨‍👩‍👧', title: "I'm a Parent", subtitle: 'Manage & monitor my child', color: AppColors.blue,
            onTap: () => Navigator.pushNamed(context, '/parent_login')),
        ],

        if (_step == 1) ...[
          const Text("What's your name? 😊", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800))
            .animate().fadeIn().slideX(begin: 0.3, end: 0),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 2)),
            child: TextField(controller: _nameCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
              decoration: const InputDecoration(hintText: 'Enter your name...', hintStyle: TextStyle(color: AppColors.textG),
                border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                prefixIcon: Icon(Icons.person_rounded, color: AppColors.primary)),
              textCapitalization: TextCapitalization.words,
              onSubmitted: (_) => _goToAvatar())),
          const SizedBox(height: 28),
          _btn('Choose Avatar →', _goToAvatar, AppColors.purpleGrad),
          const SizedBox(height: 12),
          GestureDetector(onTap: () => setState(() => _step = 0),
            child: const Text('← Back', style: TextStyle(color: AppColors.textG, fontWeight: FontWeight.w700))),
        ],

        if (_step == 2) ...[
          Text('Pick your avatar, ${_nameCtrl.text.trim()}! 🎭',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800))
              .animate().fadeIn(),
          const SizedBox(height: 20),
          // Big preview
          Text(_avatars.firstWhere((a)=>a['id']==_avatarId)['emoji']!, style: const TextStyle(fontSize: 56))
            .animate(key: ValueKey(_avatarId)).scale(begin: const Offset(0.8,0.8), end: const Offset(1,1), duration: 300.ms, curve: Curves.elasticOut),
          const SizedBox(height: 16),
          GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: _avatars.length,
            itemBuilder: (ctx, i) {
              final av = _avatars[i];
              final sel = av['id'] == _avatarId;
              return GestureDetector(
                onTap: () => setState(() => _avatarId = av['id']!),
                child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(color: sel?AppColors.primary.withOpacity(0.3):AppColors.bgCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: sel?AppColors.primary:Colors.transparent, width: 2.5),
                    boxShadow: sel?[BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 10)]:null),
                  child: Center(child: Text(av['emoji']!, style: TextStyle(fontSize: sel?34:26)))));
            }),
          const SizedBox(height: 24),
          _btn(_loading ? 'Creating...' : "Let's Go! 🚀", _loading ? null : _createChild, AppColors.greenGrad),
          const SizedBox(height: 12),
          GestureDetector(onTap: () => setState(() => _step = 1),
            child: const Text('← Back', style: TextStyle(color: AppColors.textG, fontWeight: FontWeight.w700))),
        ],
      ]))),
    ));
  }

  void _goToAvatar() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your name!'), backgroundColor: AppColors.red));
      return;
    }
    setState(() => _step = 2);
  }

  Future<void> _createChild() async {
    setState(() => _loading = true);
    await context.read<AppProvider>().createChild(_nameCtrl.text.trim(), _avatarId);
    if (mounted) Navigator.pushReplacementNamed(context, '/home');
  }
}

class _RoleCard extends StatelessWidget {
  final String emoji, title, subtitle;
  final Color color;
  final VoidCallback onTap;
  const _RoleCard({required this.emoji, required this.title, required this.subtitle, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: Container(padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 15)]),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 42)),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 19)),
          Text(subtitle, style: const TextStyle(color: AppColors.textG, fontSize: 13)),
        ])),
        Icon(Icons.arrow_forward_ios_rounded, color: color, size: 18),
      ])));
}
