import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../battle_game.dart';


class Ground extends SpriteComponent with HasGameReference<BattleGame>{
  

  Ground(Vector2 position)
    : super(
      position: position,
      size: Vector2.all(50),
      anchor: Anchor.center,
    );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final bulletImage = game.images.fromCache('ground.png');
    sprite = Sprite(bulletImage); 
    
    add(RectangleHitbox());

  }

  

}