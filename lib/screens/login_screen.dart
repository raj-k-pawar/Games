import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  String _selectedAvatar = 'avatar_1';
  bool _isLoading = false;
  int _step = 0; // 0 = name, 1 = avatar

  final List<Map<String, String>> _avatars = [
    {'id': 'avatar_1', 'emoji': '🦊', 'name': 'Fox'},
    {'id': 'avatar_2', 'emoji': '🐼', 'name': 'Panda'},
    {'id': 'avatar_3', 'emoji': '🦁', 'name': 'Lion'},
    {'id': 'avatar_4', 'emoji': '🐸', 'name': 'Frog'},
    {'id': 'avatar_5', 'emoji': '🐯', 'name': 'Tiger'},
    {'id': 'avatar_6', 'emoji': '🦄', 'name': 'Unicorn'},
    {'id': 'avatar_7', 'emoji': '🐺', 'name': 'Wolf'},
    {'id': 'avatar_8', 'emoji': '🦋', 'name': 'Butterfly'},
    {'id': 'avatar_9', 'emoji': '🐉', 'name': 'Dragon'},
    {'id': 'avatar_10', 'emoji': '🦅', 'name': 'Eagle'},
    {'id': 'avatar_11', 'emoji': '🐬', 'name': 'Dolphin'},
    {'id': 'avatar_12', 'emoji': '🦊', 'name': 'Fennec'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createProfile() async {
    if (_nameController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    await context.read<UserProvider>().createUser(
          _nameController.text.trim(),
          _selectedAvatar,
        );
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Header
                Column(
                  children: [
                    const Text('🎓', style: TextStyle(fontSize: 64))
                        .animate()
                        .scale(duration: 500.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome to\nEduQuest!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3, end: 0),
                    const SizedBox(height: 8),
                    const Text(
                      'Your learning adventure starts here!',
                      style: TextStyle(color: AppColors.textGray, fontSize: 15),
                    ).animate(delay: 400.ms).fadeIn(),
                  ],
                ),

                const SizedBox(height: 40),

                // Step indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StepDot(active: _step >= 0, label: '1', done: _step > 0),
                    Container(
                      width: 40,
                      height: 2,
                      color: _step > 0 ? AppColors.primaryPurple : AppColors.bgCardLight,
                    ),
                    _StepDot(active: _step >= 1, label: '2', done: false),
                  ],
                ),

                const SizedBox(height: 32),

                // Step 0: Name
                if (_step == 0) ...[
                  _buildNameStep().animate().fadeIn().slideX(begin: 0.3, end: 0),
                ],

                // Step 1: Avatar
                if (_step == 1) ...[
                  _buildAvatarStep().animate().fadeIn().slideX(begin: 0.3, end: 0),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What's your name? 😊",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'This will be shown on the leaderboard',
          style: TextStyle(color: AppColors.textGray, fontSize: 14),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryPurple.withOpacity(0.5), width: 2),
          ),
          child: TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            decoration: const InputDecoration(
              hintText: 'Enter your name...',
              hintStyle: TextStyle(color: AppColors.textGray),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              prefixIcon: Icon(Icons.person_rounded, color: AppColors.primaryPurple),
            ),
            textCapitalization: TextCapitalization.words,
            onSubmitted: (_) => _goToAvatarStep(),
          ),
        ),
        const SizedBox(height: 32),
        _PrimaryButton(
          label: 'Choose Your Avatar →',
          onTap: _goToAvatarStep,
          gradient: AppColors.purpleGradient,
        ),
      ],
    );
  }

  void _goToAvatarStep() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name first!'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }
    setState(() => _step = 1);
  }

  Widget _buildAvatarStep() {
    final selected = _avatars.firstWhere((a) => a['id'] == _selectedAvatar);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pick your avatar! 🎭',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),

        // Selected preview
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: AppColors.purpleGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Center(
              child: Text(
                selected['emoji']!,
                style: const TextStyle(fontSize: 50),
              ),
            ),
          ).animate(key: ValueKey(_selectedAvatar)).scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 300.ms,
                curve: Curves.elasticOut,
              ),
        ),

        const SizedBox(height: 8),
        Center(
          child: Text(
            'Hi, ${_nameController.text.trim()}! 👋',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Avatar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _avatars.length,
          itemBuilder: (context, i) {
            final avatar = _avatars[i];
            final isSelected = avatar['id'] == _selectedAvatar;
            return GestureDetector(
              onTap: () => setState(() => _selectedAvatar = avatar['id']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryPurple.withOpacity(0.3)
                      : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryPurple : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primaryPurple.withOpacity(0.4),
                            blurRadius: 12,
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    avatar['emoji']!,
                    style: TextStyle(fontSize: isSelected ? 34 : 28),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 32),

        Row(
          children: [
            Expanded(
              child: _SecondaryButton(
                label: '← Back',
                onTap: () => setState(() => _step = 0),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _PrimaryButton(
                label: _isLoading ? 'Creating...' : "Let's Go! 🚀",
                onTap: _isLoading ? null : _createProfile,
                gradient: AppColors.greenGradient,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool active;
  final String label;
  final bool done;

  const _StepDot({required this.active, required this.label, required this.done});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: active ? AppColors.purpleGradient : null,
        color: active ? null : AppColors.bgCard,
        shape: BoxShape.circle,
        border: Border.all(
          color: active ? Colors.transparent : AppColors.bgCardLight,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          done ? '✓' : label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.textGray,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final LinearGradient gradient;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          gradient: onTap != null ? gradient : null,
          color: onTap == null ? AppColors.bgCard : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: onTap != null
              ? [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.bgCardLight, width: 2),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textGray,
            ),
          ),
        ),
      ),
    );
  }
}
