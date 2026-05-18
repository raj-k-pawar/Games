import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
  @override void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final child = context.watch<AppProvider>().child!;
    return Scaffold(body: Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGrad),
      child: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(20,16,20,0), child: Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context),
            child: Container(width: 42, height: 42,
              decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(13)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18))),
          const SizedBox(width: 14),
          const Text('🛒 Rewards Shop', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)),
          const Spacer(),
          _CurrencyBadge('🪙', child.coins, AppColors.yellow),
          const SizedBox(width: 8),
          _CurrencyBadge('💎', child.gems, AppColors.cyan),
        ])),
        const SizedBox(height: 14),
        Container(margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(16)),
          child: TabBar(controller: _tab,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(gradient: AppColors.purpleGrad, borderRadius: BorderRadius.circular(14)),
            labelColor: Colors.white, unselectedLabelColor: AppColors.textG,
            labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            dividerColor: Colors.transparent,
            tabs: const [Tab(text:'🦊 Avatars'), Tab(text:'🐾 Pets'), Tab(text:'⚡ Power-ups')])),
        const SizedBox(height: 14),
        Expanded(child: TabBarView(controller: _tab, children: [
          _AvatarsTab(),
          _PetsTab(),
          _PowerupsTab(),
        ])),
      ]))));
  }
}

class _CurrencyBadge extends StatelessWidget {
  final String emoji; final int val; final Color color;
  const _CurrencyBadge(this.emoji, this.val, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.4), width: 1.5)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(emoji, style: const TextStyle(fontSize: 14)), const SizedBox(width: 4),
      Text('$val', style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 14)),
    ]));
}

// Avatars
class _AvatarsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final child = app.child!;
    return GridView.builder(padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.78),
      itemCount: ShopService.avatars.length,
      itemBuilder: (ctx, i) {
        final item = ShopService.avatars[i];
        final owned = child.unlockedAvatars.contains(item.id) || item.price == 0;
        final equipped = child.avatarId == item.id;
        final rarityColor = item.bonus=='Legendary'?AppColors.orange:item.bonus=='Epic'?AppColors.primary:item.bonus=='Rare'?AppColors.blue:AppColors.textG;
        return GestureDetector(
          onTap: () => _handleAvatar(ctx, app, item, owned, equipped, child),
          child: AnimatedContainer(duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: equipped?AppColors.primary.withOpacity(0.2):AppColors.bgCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: equipped?AppColors.primary:rarityColor.withOpacity(0.3), width: equipped?2.5:1.5),
              boxShadow: equipped?[BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 14)]:null),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(item.emoji, style: TextStyle(fontSize: owned?38:30, color: owned?null:const Color(0x55FFFFFF))),
              const SizedBox(height: 5),
              Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11)),
              const SizedBox(height: 3),
              if (item.bonus != null) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: rarityColor.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                child: Text(item.bonus!, style: TextStyle(color: rarityColor, fontSize: 9, fontWeight: FontWeight.w800))),
              const SizedBox(height: 5),
              if (owned) Text(equipped?'Equipped':'Equip', style: TextStyle(color: equipped?AppColors.green:AppColors.blue, fontSize: 10, fontWeight: FontWeight.w800))
              else Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('🪙', style: TextStyle(fontSize: 11)), const SizedBox(width: 3),
                Text('${item.price}', style: const TextStyle(color: AppColors.yellow, fontSize: 11, fontWeight: FontWeight.w800)),
              ]),
            ])).animate(delay: Duration(milliseconds: i*40)).fadeIn().scale(begin: const Offset(0.85,0.85)));
      });
  }

  void _handleAvatar(BuildContext ctx, AppProvider app, dynamic item, bool owned, bool equipped, dynamic child) {
    if (equipped) return;
    if (owned) { app.equipAvatar(item.id); _snack(ctx, '${item.emoji} ${item.name} equipped!', AppColors.green); return; }
    if (child.coins < item.price) { _snack(ctx, 'Need ${item.price - child.coins} more coins!', AppColors.red); return; }
    showDialog(context: ctx, builder: (_) => _BuyDialog(item: item, onBuy: () async {
      final ok = await app.purchaseItem(item);
      if (ctx.mounted) { Navigator.pop(ctx); if (ok) _snack(ctx, '🎉 ${item.name} unlocked!', AppColors.green); }
    }));
  }

  static void _snack(BuildContext ctx, String msg, Color c) => ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: c, behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
}

// Pets
class _PetsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final child = app.child!;
    return GridView.builder(padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.05),
      itemCount: ShopService.pets.length,
      itemBuilder: (ctx, i) {
        final item = ShopService.pets[i];
        final owned = child.unlockedPets.contains(item.id);
        return GestureDetector(
          onTap: () {
            if (owned) { ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('${item.emoji} already in your collection!'), backgroundColor: AppColors.blue, behavior: SnackBarBehavior.floating)); return; }
            if (child.coins < item.price) { ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Need ${item.price-child.coins} more coins!'), backgroundColor: AppColors.red, behavior: SnackBarBehavior.floating)); return; }
            showDialog(context: ctx, builder: (_) => _BuyDialog(item: item, onBuy: () async {
              final ok = await app.purchaseItem(item);
              if (ctx.mounted) { Navigator.pop(ctx); if (ok) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('🎉 ${item.name} joined!'), backgroundColor: AppColors.green, behavior: SnackBarBehavior.floating)); }
            }));
          },
          child: Container(
            decoration: AppDeco.card(color: owned?AppColors.green.withOpacity(0.1):AppColors.bgCard,
              glow: owned, glowColor: AppColors.green),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(item.emoji, style: const TextStyle(fontSize: 42)),
              const SizedBox(height: 6),
              Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
              const SizedBox(height: 4),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(item.bonus ?? '', style: const TextStyle(color: AppColors.green, fontSize: 11, fontWeight: FontWeight.w700))),
              const SizedBox(height: 8),
              if (owned) const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.check_circle_rounded, color: AppColors.green, size: 16), SizedBox(width: 4),
                Text('Owned', style: TextStyle(color: AppColors.green, fontSize: 12, fontWeight: FontWeight.w800)),
              ]) else Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('🪙', style: TextStyle(fontSize: 12)), const SizedBox(width: 4),
                Text('${item.price}', style: const TextStyle(color: AppColors.yellow, fontWeight: FontWeight.w900, fontSize: 13)),
              ]),
            ])).animate(delay: Duration(milliseconds: i*60)).fadeIn().scale(begin: const Offset(0.85,0.85)));
      });
  }
}

// Power-ups
class _PowerupsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final child = app.child!;
    return ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: ShopService.powerups.length,
      itemBuilder: (ctx, i) {
        final item = ShopService.powerups[i];
        final bal = item.useGems ? child.gems : child.coins;
        return GestureDetector(
          onTap: () async {
            if (bal < item.price) {
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Need ${item.price-bal} more ${item.useGems?"gems":"coins"}!'), backgroundColor: AppColors.red, behavior: SnackBarBehavior.floating));
              return;
            }
            final ok = await app.purchaseItem(item);
            if (ctx.mounted && ok) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('${item.emoji} ${item.name} activated!'), backgroundColor: AppColors.green, behavior: SnackBarBehavior.floating));
          },
          child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
            decoration: AppDeco.card(color: AppColors.bgCard),
            child: Row(children: [
              Container(width: 54, height: 54,
                decoration: BoxDecoration(color: (item.useGems?AppColors.cyan:AppColors.yellow).withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
                child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 26)))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                Text(item.description, style: const TextStyle(color: AppColors.textG, fontSize: 12)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(gradient: item.useGems?AppColors.cyanGrad:AppColors.goldGrad, borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(item.useGems?'💎':'🪙', style: const TextStyle(fontSize: 14)), const SizedBox(width: 4),
                  Text('${item.price}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                ])),
            ])).animate(delay: Duration(milliseconds: i*60)).fadeIn().slideX(begin: 0.2, end: 0));
      });
  }
}

class _BuyDialog extends StatelessWidget {
  final dynamic item; final VoidCallback onBuy;
  const _BuyDialog({required this.item, required this.onBuy});
  @override
  Widget build(BuildContext context) => Dialog(backgroundColor: AppColors.bgCard,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text(item.emoji, style: const TextStyle(fontSize: 56)),
      const SizedBox(height: 12),
      Text('Buy ${item.name}?', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(item.useGems?'💎':'🪙', style: const TextStyle(fontSize: 20)), const SizedBox(width: 6),
        Text('${item.price} ${item.useGems?"gems":"coins"}', style: const TextStyle(color: AppColors.yellow, fontWeight: FontWeight.w800, fontSize: 18)),
      ]),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: GestureDetector(onTap: () => Navigator.pop(context), child: Container(height: 48,
          decoration: BoxDecoration(color: AppColors.bgCardL, borderRadius: BorderRadius.circular(14)),
          child: const Center(child: Text('Cancel', style: TextStyle(color: AppColors.textG, fontWeight: FontWeight.w800)))))),
        const SizedBox(width: 12),
        Expanded(child: GestureDetector(onTap: onBuy, child: Container(height: 48,
          decoration: BoxDecoration(gradient: AppColors.purpleGrad, borderRadius: BorderRadius.circular(14)),
          child: const Center(child: Text('Buy!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)))))),
      ]),
    ])));
}
