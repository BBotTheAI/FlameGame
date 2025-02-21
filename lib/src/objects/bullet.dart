import 'dart:async';
import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:spacegame/src/actors/enemy.dart';
import 'package:spacegame/src/actors/player.dart';
import 'package:spacegame/src/effects/explosion.dart';

import '../../battle_game.dart';

class Bullet extends SpriteComponent with HasGameReference<BattleGame>, CollisionCallbacks{
  Bullet({
    required super.position, required this.direction, this.shooterIsPlayer = true
  })  :super(anchor: Anchor.center);

  Vector2 direction;
  double bulletSpeed = 1200;
  double enemyBulletSpeed = 500;
  int bulletDamage = 20;
  bool shooterIsPlayer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = Vector2.all(game.calculateSizeDouble(40));

    final bulletImage = game.images.fromCache('bullet.png');
    sprite = Sprite(bulletImage);    

    angle += math.atan(direction.y / direction.x);
    
    
    add(
      RectangleHitbox(collisionType: CollisionType.active),
    );
    
  }


  @override
  void update(double dt) {
    super.update(dt);
    if(shooterIsPlayer) position += direction * bulletSpeed * dt;
    else position += direction * enemyBulletSpeed * dt;

    if (shooterIsPlayer && (position.distanceTo(game.getPlayerPosition()) > 1000)) removeFromParent();
   

  }




@override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Enemy && shooterIsPlayer) {
      other.takeHit(bulletDamage);
    }

    if (other is Player && !shooterIsPlayer) {
      other.getHit(bulletDamage);
    }


    if(shooterIsPlayer) {

      if(!(other is Player || other is Bullet || other is Explosion)) removeFromParent();

    }else {
      if(!(other is Enemy || other is Bullet || other is Explosion)) removeFromParent();
    }
   
  }













  
}