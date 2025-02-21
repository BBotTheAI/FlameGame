import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/src/UI/enemynumtext.dart';
import 'package:spacegame/src/UI/playerhealthbar.dart';
import 'package:spacegame/src/actors/enemy.dart';
import 'package:spacegame/src/buttons/buttoncontainer.dart';
import 'package:spacegame/src/effects/explosion.dart';
import 'package:spacegame/src/objects/bomb.dart';
import 'package:spacegame/src/objects/bullet.dart';

import 'src/actors/player.dart';
import 'src/managers/enemymanager.dart';
import 'src/managers/skymanager.dart';
import 'src/objects/ground.dart';
import 'src/objects/play_area.dart';


enum PlayState { welcome, playing, gameOver, won }

class BattleGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection, TapDetector {
  BattleGame();

  var random = Random();
  late Player _player;
  late SkyManager _skyManager;
  late EnemyManager _enemyManager;  
  late Playerhealthbar _playerhealthbar;
  late Buttoncontainer _buttoncontainer;
  late Enemynumtext _enemynumtext;
  double objectSpeed = 0;

  final double gravity = 15;

  int moveDirection = 0;

  bool disabledOnce = false;

  double defaultGameSizeY = 736;
  double defaultGameSizeX = 1536;
 

  late PlayState _playState;                                    
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
    }
  }



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
   

    
    
    playState = PlayState.welcome; 
    

  }



  void startGame() {
    if (playState == PlayState.playing) return;

    world.removeAll(world.children.query<Player>());
    world.removeAll(world.children.query<Enemy>());
    world.removeAll(world.children.query<Bullet>());
    world.removeAll(world.children.query<Bomb>());
    world.removeAll(world.children.query<SkyManager>());
    world.removeAll(world.children.query<EnemyManager>());
    world.removeAll(world.children.query<Playerhealthbar>());
    world.removeAll(world.children.query<Buttoncontainer>());
    world.removeAll(world.children.query<Ground>());
    world.removeAll(world.children.query<Explosion>());
    world.removeAll(world.children.query<Enemynumtext>());

    playState = PlayState.playing;

    disabledOnce = false;

    world.add(Ground(Vector2(0, -300)));

    makeTempGround();

    _player = Player(position: (makePosition(0, 600)));
    world.add(_player);    
   
    _skyManager = SkyManager(position: Vector2(0, 0));
    world.add(_skyManager);

    _enemyManager = EnemyManager(position: Vector2(0, 0));
    world.add(_enemyManager);
    
    _playerhealthbar = Playerhealthbar(position: Vector2(-size.x*3/8, -size.y * 2 / 3), size: Vector2(size.x/30, size.y/3));
    world.add(_playerhealthbar);   

    _buttoncontainer = Buttoncontainer(position: Vector2(0, -size.y/20), size: Vector2(size.x, size.y/3)); 
    world.add(_buttoncontainer);

    _enemynumtext = Enemynumtext(position: Vector2(-size.x/2, -size.y));
    world.add(_enemynumtext);

    

    
    
  }

  @override                                                     
  void onTap() {
    super.onTap();
    startGame();
  }    

  


  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 90, 118, 131);
  }



  Vector2 makePosition(double x, double y) {
    return Vector2(x, -y);
  }

  void makeTempGround() {
    for(int i = (-size.x/2).toInt(); i <= (size.x/2).toInt(); i += 50) {
      world.add(Ground(makePosition(i.toDouble(), 0)));
    }
  }

  Vector2 getPlayerPosition() {
    return _player.position;
  }

  void enemyDied() {
    _enemyManager.enemyCount--;
    _enemyManager.totalEnemies--;
    _enemyManager.spawner();
  }


  

  @override
  void update(double dt) {
    super.update(dt);

    if(playState == PlayState.playing) {
      _playerhealthbar.updateBar(_player.getHealth());
      _enemynumtext.text = "Enemies remaining: " + _enemyManager.totalEnemies.toString();
    }

    if((playState == PlayState.gameOver || playState == PlayState.won) && !disabledOnce) {
      _buttoncontainer.disableButtons();
      disabledOnce = true;
    }
    
    
  }

 double calculateSizeDouble(double defaultSize) {
  return (size.x * defaultSize) / defaultGameSizeX;
 }





}
