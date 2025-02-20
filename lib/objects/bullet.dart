import 'dart:async';
import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:spacegame/actors/enemy.dart';
import 'package:spacegame/actors/player.dart';
import 'package:spacegame/effects/explosion.dart';

import '../battle_game.dart';

class Bullet extends SpriteComponent with HasGameReference<BattleGame>, CollisionCallbacks{
  Bullet({
    required super.position, required this.direction, this.shooterIsPlayer = true
  })  :super(anchor: Anchor.center, size: Vector2.all(40));

  Vector2 direction;
  double bulletSpeed = 15;
  double enemyBulletSpeed = 8;
  int bulletDamage = 20;
  bool shooterIsPlayer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final bulletImage = game.images.fromCache('bullet.png');
    sprite = Sprite(bulletImage);    

    angle += math.atan(direction.y / direction.x);
    
    
    add(
      RectangleHitbox(collisionType: CollisionType.active),
    );
    
  }


  @override
  void update(double dt) {
    
    if(shooterIsPlayer) position += direction * bulletSpeed;
    else position += direction * enemyBulletSpeed;

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