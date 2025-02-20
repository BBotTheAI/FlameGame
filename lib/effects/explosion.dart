import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:spacegame/actors/player.dart';

import '../battle_game.dart';

class Explosion extends SpriteAnimationComponent with HasGameReference<BattleGame>, CollisionCallbacks{
  Explosion({
    required super.position,
  }) : super(
          anchor: Anchor.center,
          removeOnFinish: true,
        );

  int expDamage = 10;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = Vector2.all(game.calculateSizeDouble(150));


    animation = await game.loadSpriteAnimation(
      'explosion.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );

    
    add(RectangleHitbox(collisionType: CollisionType.passive, size: size * (3/4)));


  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player) other.getHit(expDamage);
    
  }

  



}