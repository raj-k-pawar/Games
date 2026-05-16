import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
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
                    const Text('🛒 Rewards Shop',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                    const Spacer(),
                    // Coin balance
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryYellow.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryYellow.withOpacity(0.4), width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Text('🪙', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 5),
                          Text(
                            '${user.coins}',
                            style: const TextStyle(
                                color: AppColors.primaryYellow, fontWeight: FontWeight.w900, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    gradient: AppColors.purpleGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textGray,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: '🦊 Avatars'),
                    Tab(text: '🐾 Pets'),
                    Tab(text: '⚡ Power-ups'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _AvatarsTab(),
                    _PetsTab(),
                    _PowerupsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Avatars Tab ──────────────────────────────────────────────────────────────

class _AvatarsTab extends StatelessWidget {
  final List<Map<String, dynamic>> _avatars = const [
    {'id': 'avatar_1', 'emoji': '🦊', 'name': 'Fox', 'price': 0, 'rarity': 'Common'},
    {'id': 'avatar_2', 'emoji': '🐼', 'name': 'Panda', 'price': 0, 'rarity': 'Common'},
    {'id': 'avatar_3', 'emoji': '🦁', 'name': 'Lion', 'price': 100, 'rarity': 'Rare'},
    {'id': 'avatar_4', 'emoji': '🐸', 'name': 'Frog', 'price': 50, 'rarity': 'Common'},
    {'id': 'avatar_5', 'emoji': '🐯', 'name': 'Tiger', 'price': 150, 'rarity': 'Rare'},
    {'id': 'avatar_6', 'emoji': '🦄', 'name': 'Unicorn', 'price': 300, 'rarity': 'Epic'},
    {'id': 'avatar_7', 'emoji': '🐺', 'name': 'Wolf', 'price': 100, 'rarity': 'Rare'},
    {'id': 'avatar_8', 'emoji': '🦋', 'name': 'Butterfly', 'price': 200, 'rarity': 'Rare'},
    {'id': 'avatar_9', 'emoji': '🐉', 'name': 'Dragon', 'price': 500, 'rarity': 'Legendary'},
    {'id': 'avatar_10', 'emoji': '🦅', 'name': 'Eagle', 'price': 200, 'rarity': 'Rare'},
    {'id': 'avatar_11', 'emoji': '🐬', 'name': 'Dolphin', 'price': 150, 'rarity': 'Rare'},
    {'id': 'avatar_12', 'emoji': '🦊', 'name': 'Fennec', 'price': 250, 'rarity': 'Epic'},
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user!;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _avatars.length,
      itemBuilder: (context, i) {
        final avatar = _avatars[i];
        final isOwned = user.unlockedAvatars.contains(avatar['id']) || (avatar['price'] as int) == 0;
        final isEquipped = user.avatarId == avatar['id'];
        final rarityColors = {
          'Common': AppColors.textGray,
          'Rare': AppColors.primaryBlue,
          'Epic': AppColors.primaryPurple,
          'Legendary': AppColors.primaryOrange,
        };
        final rarityColor = rarityColors[avatar['rarity']] ?? AppColors.textGray;

        return GestureDetector(
          onTap: () => _handleAvatarTap(context, avatar, isOwned, isEquipped, user),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isEquipped ? AppColors.primaryPurple.withOpacity(0.2) : AppColors.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isEquipped ? AppColors.primaryPurple : rarityColor.withOpacity(0.3),
                width: isEquipped ? 2.5 : 1.5,
              ),
              boxShadow: isEquipped
                  ? [BoxShadow(color: AppColors.primaryPurple.withOpacity(0.3), blurRadius: 15)]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Text(
                      avatar['emoji'] as String,
                      style: TextStyle(fontSize: isOwned ? 40 : 32, color: isOwned ? null : const Color(0x66FFFFFF)),
                    ),
                    if (isEquipped)
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 10),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  avatar['name'] as String,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: rarityColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    avatar['rarity'] as String,
                    style: TextStyle(color: rarityColor, fontSize: 9, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 6),
                if (isOwned)
                  Text(
                    isEquipped ? 'Equipped' : 'Equip',
                    style: TextStyle(
                      color: isEquipped ? AppColors.primaryGreen : AppColors.primaryBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 10)),
                      const SizedBox(width: 2),
                      Text(
                        '${avatar['price']}',
                        style: const TextStyle(
                            color: AppColors.primaryYellow, fontSize: 11, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
              ],
            ),
          ).animate(delay: Duration(milliseconds: i * 40)).fadeIn().scale(begin: const Offset(0.8, 0.8)),
        );
      },
    );
  }

  void _handleAvatarTap(BuildContext context, Map<String, dynamic> avatar, bool isOwned, bool isEquipped, dynamic user) {
    if (isEquipped) return;
    if (isOwned) {
      context.read<UserProvider>().updateAvatar(avatar['id'] as String);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${avatar['emoji']} ${avatar['name']} equipped!'),
          backgroundColor: AppColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final price = avatar['price'] as int;
    if (user.coins < price) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Need ${price - user.coins} more coins! 🪙'),
          backgroundColor: AppColors.primaryRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(avatar['emoji'] as String, style: const TextStyle(fontSize: 56)),
              const SizedBox(height: 12),
              Text('Buy ${avatar['name']}?',
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 6),
                  Text(
                    '$price coins',
                    style: const TextStyle(color: AppColors.primaryYellow, fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(color: AppColors.bgCardLight, borderRadius: BorderRadius.circular(14)),
                        child: const Center(child: Text('Cancel', style: TextStyle(color: AppColors.textGray, fontWeight: FontWeight.w800))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        await context.read<UserProvider>().spendCoins(price);
                        user.unlockedAvatars.add(avatar['id']);
                        await context.read<UserProvider>().updateAvatar(avatar['id'] as String);
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(gradient: AppColors.purpleGradient, borderRadius: BorderRadius.circular(14)),
                        child: const Center(child: Text('Buy!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Pets Tab ─────────────────────────────────────────────────────────────────

class _PetsTab extends StatelessWidget {
  final List<Map<String, dynamic>> _pets = const [
    {'id': 'pet_1', 'emoji': '🐱', 'name': 'Kitty', 'price': 200, 'bonus': '+5% XP'},
    {'id': 'pet_2', 'emoji': '🐶', 'name': 'Puppy', 'price': 200, 'bonus': '+10 coins/game'},
    {'id': 'pet_3', 'emoji': '🐣', 'name': 'Chick', 'price': 150, 'bonus': '+1 skip lifeline'},
    {'id': 'pet_4', 'emoji': '🦜', 'name': 'Parrot', 'price': 300, 'bonus': '+5 sec timer'},
    {'id': 'pet_5', 'emoji': '🐢', 'name': 'Turtle', 'price': 250, 'bonus': '+1 50:50'},
    {'id': 'pet_6', 'emoji': '🦊', 'name': 'Kitsune', 'price': 500, 'bonus': '+10% XP'},
    {'id': 'pet_7', 'emoji': '🐲', 'name': 'Drago', 'price': 800, 'bonus': '+2x coins'},
    {'id': 'pet_8', 'emoji': '🦋', 'name': 'Flutter', 'price': 350, 'bonus': '+5% accuracy XP'},
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user!;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: _pets.length,
      itemBuilder: (context, i) {
        final pet = _pets[i];
        final isOwned = user.unlockedPets.contains(pet['id']);

        return GestureDetector(
          onTap: () => _handlePetTap(context, pet, isOwned, user),
          child: Container(
            decoration: BoxDecoration(
              color: isOwned ? AppColors.primaryGreen.withOpacity(0.1) : AppColors.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isOwned ? AppColors.primaryGreen.withOpacity(0.5) : AppColors.bgCardLight,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(pet['emoji'] as String, style: const TextStyle(fontSize: 44)),
                const SizedBox(height: 6),
                Text(pet['name'] as String,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    pet['bonus'] as String,
                    style: const TextStyle(
                        color: AppColors.primaryGreen, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 8),
                if (isOwned)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen, size: 16),
                      SizedBox(width: 4),
                      Text('Owned', style: TextStyle(color: AppColors.primaryGreen, fontSize: 12, fontWeight: FontWeight.w800)),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        '${pet['price']}',
                        style: const TextStyle(color: AppColors.primaryYellow, fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                    ],
                  ),
              ],
            ),
          ).animate(delay: Duration(milliseconds: i * 60)).fadeIn().scale(begin: const Offset(0.85, 0.85)),
        );
      },
    );
  }

  void _handlePetTap(BuildContext context, Map<String, dynamic> pet, bool isOwned, dynamic user) {
    if (isOwned) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${pet['emoji']} ${pet['name']} is already in your collection!'),
          backgroundColor: AppColors.primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final price = pet['price'] as int;
    if (user.coins < price) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Need ${price - user.coins} more coins!'),
          backgroundColor: AppColors.primaryRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    context.read<UserProvider>().spendCoins(price);
    user.unlockedPets.add(pet['id']);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 ${pet['name']} joined your team!'),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ── Power-ups Tab ─────────────────────────────────────────────────────────────

class _PowerupsTab extends StatelessWidget {
  final List<Map<String, dynamic>> _powerups = const [
    {'emoji': '⏭️', 'name': 'Skip Pack', 'desc': '5 extra skip lifelines', 'price': 50, 'gems': false},
    {'emoji': '⏱️', 'name': 'Time Freeze', 'desc': '5 extra time lifelines', 'price': 60, 'gems': false},
    {'emoji': '5️⃣0️⃣', 'name': '50:50 Pack', 'desc': '3 extra 50:50 lifelines', 'price': 80, 'gems': false},
    {'emoji': '2️⃣✖️', 'name': 'Double XP', 'desc': '2x XP for next 5 games', 'price': 3, 'gems': true},
    {'emoji': '💰', 'name': 'Coin Boost', 'desc': '2x coins for next 10 games', 'price': 2, 'gems': true},
    {'emoji': '🛡️', 'name': 'Streak Shield', 'desc': 'Protect your streak once', 'price': 5, 'gems': true},
    {'emoji': '🎁', 'name': 'Mystery Box', 'desc': 'Random reward inside!', 'price': 1, 'gems': true},
    {'emoji': '⭐', 'name': 'Star Boost', 'desc': 'Guaranteed 3 stars next game', 'price': 8, 'gems': true},
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user!;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _powerups.length,
      itemBuilder: (context, i) {
        final item = _powerups[i];
        final isGems = item['gems'] as bool;

        return GestureDetector(
          onTap: () => _handlePurchase(context, item, user, isGems),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: AppDecorations.cardDecoration(color: AppColors.bgCard),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (isGems ? AppColors.primaryCyan : AppColors.primaryYellow).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(child: Text(item['emoji'] as String, style: const TextStyle(fontSize: 28))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name'] as String,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                      Text(item['desc'] as String,
                          style: const TextStyle(color: AppColors.textGray, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isGems ? AppColors.cyanGradient : AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(isGems ? '💎' : '🪙', style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        '${item['price']}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate(delay: Duration(milliseconds: i * 60)).fadeIn().slideX(begin: 0.2, end: 0),
        );
      },
    );
  }

  void _handlePurchase(BuildContext context, Map<String, dynamic> item, dynamic user, bool isGems) {
    final price = item['price'] as int;
    final balance = isGems ? user.gems as int : user.coins as int;
    final currency = isGems ? 'gems 💎' : 'coins 🪙';

    if (balance < price) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Need ${price - balance} more $currency!'),
          backgroundColor: AppColors.primaryRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (!isGems) context.read<UserProvider>().spendCoins(price);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['emoji']} ${item['name']} activated!'),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
