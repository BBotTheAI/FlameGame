import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';

import '../../battle_game.dart';
import '../objects/ground.dart';

class Player extends SpriteAnimationComponent 
    with HasGameReference<BattleGame>, KeyboardHandler, CollisionCallbacks{
  Player({
    required super.position,
  }) : super(anchor: Anchor.center);

  int horizontalDirection = 0;
  bool hasJumped = false;
  bool isOnGround = false;
  //final double gravity = 15;
  final double moveSpeed = 300;
  final Vector2 velocity = Vector2.zero();
  final double jumpSpeed = 800;
  final double terminalVelocity = 400;
  final Vector2 fromAbove = Vector2(0, -1);
  int health = 100;
  bool useButtons = true;


  @override
  Future<void> onLoad() async {
    
    size = Vector2.all(game.calculateSizeDouble(64));


    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('character.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );
  
    add(
      CircleHitbox()      
    );

  }








  
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);
    return true;
  }

  @override
  void update(double dt) {

    if(game.moveDirection <= 1 && game.moveDirection >= -1) horizontalDirection = game.moveDirection;
    else if (game.moveDirection == 2) hasJumped = true;






    velocity.x = horizontalDirection * moveSpeed;
    game.objectSpeed = 0;
    
    velocity.y += game.gravity + 10;

    if (hasJumped) {
      if (isOnGround) {
        velocity.y = -jumpSpeed;
        isOnGround = false;
      }
      hasJumped = false;
    }

    // Prevent ember from jumping to crazy fast.
    velocity.y = velocity.y.clamp(-jumpSpeed, terminalVelocity);

    // Adjust ember position.
    position += velocity * dt;

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    if(position.y > game.size.y * 2 ) {
      add(RemoveEffect(
        delay: 0.35,
        onComplete: () {                                   
          game.playState = PlayState.gameOver;
        }));

    }



    super.update(dt);

  }


  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    
    if (other is Ground) {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance.
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // If collision normal is almost upwards,
        // ember must be on ground.
        if (fromAbove.dot(collisionNormal) > 0.9) {
          isOnGround = true;
        }

        // Resolve collision by moving ember along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
      }

      
    }
    
  }



  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if(health <= 0) {
      add(RemoveEffect(
            delay: 0.35,
            onComplete: () {                                   
              game.playState = PlayState.gameOver;
            }));       
    }
  }









 
  void getHit(int damage) {
    health -= damage;
  }



  int getHealth() {
    return health;
  }

  


  


}