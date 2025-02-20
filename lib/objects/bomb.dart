import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../battle_game.dart';
import '../effects/explosion.dart';

class Bomb extends SpriteAnimationComponent with HasGameReference<BattleGame>, CollisionCallbacks{
  Bomb({
    required super.position,
  }) : super(size: Vector2(25, 50), anchor: Anchor.center);

  final Vector2 velocity = Vector2.zero();
  final double gravity = 2.5;






  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'bomb.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2(8, 16),
      ),
    );
    
    flipVertically();

    add(
      RectangleHitbox(collisionType: CollisionType.passive),
    );
    
  }

  @override
  void update(double dt) {
    super.update(dt);
    if(velocity.y <= 1000) velocity.y += gravity;

    position += velocity * dt;

    if(position.y > 100) {
      removeFromParent();
      
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    removeFromParent();
    game.world.add(Explosion(position:  position));

    
    
  }
  
}