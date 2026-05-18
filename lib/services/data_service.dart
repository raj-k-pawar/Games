import '../models/models.dart';

class SubjectService {
  static const List<Subject> subjects = [
    Subject(id:'mathematics', name:'Mathematics', emoji:'🔢', description:'Numbers, puzzles & logic', gradColors:[0xFF1D4ED8,0xFF3B82F6]),
    Subject(id:'science',     name:'Science',     emoji:'🔬', description:'Explore the universe',   gradColors:[0xFF16A34A,0xFF22C55E]),
    Subject(id:'history',     name:'History',     emoji:'🏛️', description:'Stories from the past', gradColors:[0xFFEA580C,0xFFF97316]),
    Subject(id:'logic',       name:'Logic & IQ',  emoji:'🧠', description:'Puzzles & brain games',  gradColors:[0xFF7C3AED,0xFF9B59F5]),
    Subject(id:'coding',      name:'Coding & AI', emoji:'💻', description:'Tech & programming',     gradColors:[0xFF0891B2,0xFF06B6D4]),
    Subject(id:'geography',   name:'Geography',   emoji:'🌍', description:'Explore our world',      gradColors:[0xFF059669,0xFF10B981]),
    Subject(id:'english',     name:'English',     emoji:'📝', description:'Words & communication',  gradColors:[0xFFBE185D,0xFFEC4899]),
    Subject(id:'finance',     name:'Finance',     emoji:'💰', description:'Money & business basics', gradColors:[0xFFB45309,0xFFFBBF24]),
  ];

  static Subject? byId(String id) {
    try { return subjects.firstWhere((s)=>s.id==id); } catch(_) { return null; }
  }
}

class ShopService {
  static final List<ShopItem> avatars = [
    ShopItem(id:'avatar_fox',     name:'Fox',       emoji:'🦊', description:'Free starter avatar', type:'avatar', price:0),
    ShopItem(id:'avatar_panda',   name:'Panda',     emoji:'🐼', description:'Cool & calm',         type:'avatar', price:0),
    ShopItem(id:'avatar_lion',    name:'Lion',      emoji:'🦁', description:'Brave & bold',        type:'avatar', price:100, bonus:'Rare'),
    ShopItem(id:'avatar_frog',    name:'Frog',      emoji:'🐸', description:'Quick & smart',       type:'avatar', price:50),
    ShopItem(id:'avatar_tiger',   name:'Tiger',     emoji:'🐯', description:'Fast & fierce',       type:'avatar', price:150, bonus:'Rare'),
    ShopItem(id:'avatar_unicorn', name:'Unicorn',   emoji:'🦄', description:'Magical & unique',    type:'avatar', price:300, bonus:'Epic'),
    ShopItem(id:'avatar_wolf',    name:'Wolf',      emoji:'🐺', description:'Clever & fierce',     type:'avatar', price:100),
    ShopItem(id:'avatar_dragon',  name:'Dragon',    emoji:'🐉', description:'Legendary power',     type:'avatar', price:500, bonus:'Legendary'),
    ShopItem(id:'avatar_eagle',   name:'Eagle',     emoji:'🦅', description:'Sharp & fast',        type:'avatar', price:200, bonus:'Rare'),
    ShopItem(id:'avatar_bear',    name:'Bear',      emoji:'🐻', description:'Strong & steady',     type:'avatar', price:80),
    ShopItem(id:'avatar_dolphin', name:'Dolphin',   emoji:'🐬', description:'Smart & playful',     type:'avatar', price:120, bonus:'Rare'),
    ShopItem(id:'avatar_cat',     name:'Cat',       emoji:'🐱', description:'Curious & clever',    type:'avatar', price:60),
  ];

  static final List<ShopItem> pets = [
    ShopItem(id:'pet_kitty',   name:'Kitty',   emoji:'🐱', description:'+5% XP bonus',        type:'pet', price:200, bonus:'+5% XP'),
    ShopItem(id:'pet_puppy',   name:'Puppy',   emoji:'🐶', description:'+10 coins per game',   type:'pet', price:200, bonus:'+10 coins'),
    ShopItem(id:'pet_chick',   name:'Chick',   emoji:'🐣', description:'+1 extra skip',        type:'pet', price:150, bonus:'+1 Skip'),
    ShopItem(id:'pet_parrot',  name:'Parrot',  emoji:'🦜', description:'+5 seconds on timer',  type:'pet', price:300, bonus:'+5 sec'),
    ShopItem(id:'pet_turtle',  name:'Turtle',  emoji:'🐢', description:'+1 extra 50:50',       type:'pet', price:250, bonus:'+1 50:50'),
    ShopItem(id:'pet_dragon',  name:'Drago',   emoji:'🐲', description:'2x coin multiplier',   type:'pet', price:800, bonus:'2x Coins'),
    ShopItem(id:'pet_phoenix', name:'Phoenix', emoji:'🦅', description:'+10% XP on all games', type:'pet', price:600, bonus:'+10% XP'),
    ShopItem(id:'pet_bunny',   name:'Bunny',   emoji:'🐰', description:'+1 extra time boost',  type:'pet', price:180, bonus:'+1 Time'),
  ];

  static final List<ShopItem> powerups = [
    ShopItem(id:'pu_skip5',      name:'Skip Pack',     emoji:'⏭️', description:'5 extra skip lifelines',   type:'powerup', price:80),
    ShopItem(id:'pu_time5',      name:'Time Pack',     emoji:'⏱️', description:'5 extra time lifelines',   type:'powerup', price:80),
    ShopItem(id:'pu_fifty3',     name:'50:50 Pack',    emoji:'🎯', description:'3 extra 50:50 lifelines',  type:'powerup', price:100),
    ShopItem(id:'pu_2xp',        name:'Double XP',     emoji:'2️⃣✖️', description:'2x XP next 5 games',  type:'powerup', price:3, useGems:true),
    ShopItem(id:'pu_coinboost',  name:'Coin Boost',    emoji:'💰', description:'2x coins next 10 games',  type:'powerup', price:2, useGems:true),
    ShopItem(id:'pu_shield',     name:'Streak Shield', emoji:'🛡️', description:'Protect your streak once',type:'powerup', price:5, useGems:true),
    ShopItem(id:'pu_mystery',    name:'Mystery Box',   emoji:'🎁', description:'Random surprise reward!',  type:'powerup', price:1, useGems:true),
    ShopItem(id:'pu_revive',     name:'Revive',        emoji:'💫', description:'Continue after wrong',     type:'powerup', price:3, useGems:true),
  ];
}

class AvatarService {
  static const Map<String,String> emojiMap = {
    'avatar_fox':'🦊','avatar_panda':'🐼','avatar_lion':'🦁','avatar_frog':'🐸',
    'avatar_tiger':'🐯','avatar_unicorn':'🦄','avatar_wolf':'🐺','avatar_dragon':'🐉',
    'avatar_eagle':'🦅','avatar_bear':'🐻','avatar_dolphin':'🐬','avatar_cat':'🐱',
  };
  static String emoji(String id) => emojiMap[id] ?? '🦊';
}
