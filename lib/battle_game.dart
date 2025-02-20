import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/UI/playerhealthbar.dart';
import 'package:spacegame/buttons/movebutton.dart';
import 'package:spacegame/buttons/shootButton.dart';

import 'actors/player.dart';
import 'managers/enemymanager.dart';
import 'managers/skymanager.dart';
import 'objects/ground.dart';

class BattleGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  BattleGame();

  var random = Random();
  late Player _player;
  late SkyManager _skyManager;
  late EnemyManager _enemyManager;
  late Shootbutton _shootButton;
  late Playerhealthbar _playerhealthbar;
  late MoveButton _rightbutton;
  late MoveButton _leftbutton;
  late MoveButton _jumpbutton;
  double objectSpeed = 0;

  final double gravity = 15;

  int moveDirection = 0;

  @override
  Future<void> onLoad() async {
    
    super.onLoad();
    await images.loadAll([
      'character.png',
      'bomb.png',
      'explosion.png',
      'bullet.png',
      'enemy.png',
      'ground.png',
    ]);

    
  
    camera.viewfinder.anchor = Anchor.bottomCenter;
   
    

    makeTempGround();

    startGame();
    

  }



  void startGame() {

    _player = Player(position: (makePosition(0, 200)));
    world.add(_player);    
   
    _skyManager = SkyManager(position: Vector2(0, 0));
    world.add(_skyManager);

    _enemyManager = EnemyManager(position: Vector2(0, 0));
    world.add(_enemyManager);

    _shootButton = Shootbutton(position: Vector2(canvasSize.x / 2 - 50 , -50));
    world.add(_shootButton);
    
    _playerhealthbar = Playerhealthbar(position: Vector2(-canvasSize.x*3/8, -canvasSize.y / 2));
    world.add(_playerhealthbar);    

    Vector2 buttonSizes = Vector2.all(128);
    int padding = 50;

    _leftbutton = MoveButton(position: Vector2(-size.x/2 + buttonSizes.x/2 + padding, -110), size: buttonSizes);
    _leftbutton.direction = -1;
    _leftbutton.rotateAngle = _leftbutton.degree90 * 2;
    world.add(_leftbutton);

    _rightbutton = MoveButton(position: Vector2(_leftbutton.position.x + buttonSizes.x + padding, -110), size: buttonSizes);
    _rightbutton.direction = 1;
    world.add(_rightbutton);

    _jumpbutton = MoveButton(position: Vector2(_leftbutton.position.x + buttonSizes.x/2 + padding/2, -230), size: buttonSizes);
    _jumpbutton.direction = 2;
    _jumpbutton.rotateAngle = _jumpbutton.degree90 * 3;
    world.add(_jumpbutton);
    
  }

  


  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 90, 118, 131);
  }



  Vector2 makePosition(x, y) {
    return Vector2(x, -y);
  }

  void makeTempGround() {
    for(int i = -450; i <= 450; i += 50) {
      world.add(Ground(makePosition(i, 0)));
    }
  }

  Vector2 getPlayerPosition() {
    return _player.position;
  }

  void enemyDied() {
    _enemyManager.enemyCount--;
    _enemyManager.spawner();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _playerhealthbar.updateBar(_player.getHealth());
    
  }
 


}
