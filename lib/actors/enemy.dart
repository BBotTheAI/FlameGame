import 'dart:async';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:spacegame/effects/explosion.dart';
import 'package:spacegame/UI/healthbar.dart';

import '../battle_game.dart';
import '../objects/bullet.dart';

class Enemy extends SpriteAnimationComponent with HasGameReference<BattleGame>, CollisionCallbacks {
  Enemy({
    super.position,
  }) : super(
          size: Vector2.all(50),
          anchor: Anchor.center,
        );

  var random = Random();
  var randomLength;
  bool isRanged = true;
  final Vector2 velocity = Vector2.zero();
  int health = 100;
  var countdown = Timer(3);
  late Healthbar _healthbar;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'enemy.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2.all(16),
      ),
    );

    //randomLength = random.nextInt(150);
    if(position.x > 0) randomLength = random.nextInt(500);
    else randomLength = random.nextInt(500) * -1;

    add(RectangleHitbox(collisionType: CollisionType.passive));

    _healthbar = Healthbar(position: Vector2.zero());
    add(_healthbar);

    countdown.limit = 3 + random.nextInt(3).toDouble();
  }

  @override
  void update(double dt) {
    super.update(dt);
    countdown.update(dt);
    moveEnemy(isRanged, dt);
    _healthbar.updateColor(health);

    if(health <= 0) {
      die();
    }

    shoot(dcfs(game.getPlayerPosition()).normalized());    

  }


  void moveEnemy(bool ranged, double dt) {

    if(ranged) {
      if(position.x.abs() > randomLength.abs()) {
        if(position.x > 0) position.x--;
        else position.x++;
      }
    }else {
      if((position.x - game.getPlayerPosition().x).abs() > 25) {
        if(position.x > game.getPlayerPosition().x) position.x--;
        else position.x++;
      }

      position.y += game.gravity * dt;
    }



  }

  void takeHit(int damage) {
    health -= damage;
  }

  void shoot(Vector2 direction){
    if(countdown.finished && direction != Vector2.zero()) {
      game.world.add(Bullet(position: position, direction: direction, shooterIsPlayer: false));
      countdown.start();
    }    
  }

  Vector2 dcfs(Vector2 target) {
    double a = position.x - target.x;
    double b = position.y - target.y;

    return Vector2(a, b) * -1;
  }

  void die() {
    removeFromParent();
    game.enemyDied();
    Explosion exp = new Explosion(position: position);
    exp.size = size;
    game.world.add(exp);
  }



}