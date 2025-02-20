import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/UI/playerhealthbar.dart';
import 'package:spacegame/actors/enemy.dart';
import 'package:spacegame/buttons/buttoncontainer.dart';
import 'package:spacegame/effects/explosion.dart';
import 'package:spacegame/objects/bomb.dart';
import 'package:spacegame/objects/bullet.dart';

import 'actors/player.dart';
import 'managers/enemymanager.dart';
import 'managers/skymanager.dart';
import 'objects/ground.dart';



class BattleGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection, TapDetector {
  BattleGame();

  var random = Random();
  late Player _player;
  late SkyManager _skyManager;
  late EnemyManager _enemyManager;  
  late Playerhealthbar _playerhealthbar;
  late Buttoncontainer _buttoncontainer;
  double objectSpeed = 0;

  final double gravity = 15;

  int moveDirection = 0;

  double defaultGameSizeY = 736;
  double defaultGameSizeX = 1536;



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
    
    _playerhealthbar = Playerhealthbar(position: Vector2(-size.x*3/8, -size.y * 2 / 3), size: Vector2(size.x/30, size.y/3));
    world.add(_playerhealthbar);   

    _buttoncontainer = Buttoncontainer(position: Vector2(0, -size.y/20), size: Vector2(size.x, size.y/3)); 
    world.add(_buttoncontainer);

    

    
    
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

 double calculateSizeDouble(double defaultSize) {
  return (size.x * defaultSize) / defaultGameSizeX;
 }




 


}
