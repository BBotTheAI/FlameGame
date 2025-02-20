import 'dart:async';
import 'dart:ui';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/objects/bullet.dart';

import '../battle_game.dart';

class Shootbutton extends PositionComponent {
  Shootbutton({
    required super.position,
  })  : super(anchor: Anchor.bottomRight, size: Vector2.all(256));

  final _paint = Paint()..color = const Color(0x448BA8FF);
  late DragButton button;
  
  @override
  FutureOr<void> onLoad() {
    
    button = new DragButton(position: Vector2(size.x/2, size.y/2), parentSize: size);
    add(button);

    
  }

  
  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(128, 128), 125.0, _paint);
    

    super.render(canvas);
  }
  
}












class DragButton extends PositionComponent with DragCallbacks, HasGameReference<BattleGame>{
  DragButton({
    required super.position, required this.parentSize,
  })  : super(anchor: Anchor.center, size: Vector2.all(parentSize.x / 2));

    final _paint = Paint()..color = const Color.fromRGBO(255, 255, 255, 1);
    Vector2 parentSize;
    final countdown = Timer(0.25);
    bool isShooting = false;
    Vector2 shootingDirection = Vector2.zero();
    


  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(size.x/2, size.y/2), 32, _paint);    
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    position = (position + event.localDelta);

    if (sqrt(pow((position.x - size.x), 2) + pow((position.y - size.y), 2)) >= 125) {
      position = (position - event.localDelta);
    }


    shootingDirection += event.localDelta;
    isShooting = true;

    


    
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    position = parentSize/2;
    shootingDirection = Vector2.zero();
    isShooting = false;
  }

  void shoot(Vector2 direction){
    if(countdown.finished && direction != Vector2.zero()) {
      game.world.add(Bullet(position: game.getPlayerPosition(), direction: direction));
      countdown.start();
    }    
  }

  @override
  void update(double dt) {
    countdown.update(dt);

    if(isShooting) shoot(shootingDirection.normalized());
  }

  
}