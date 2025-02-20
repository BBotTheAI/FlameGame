import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:spacegame/actors/enemy.dart';

import '../battle_game.dart';

class EnemyManager extends PositionComponent with HasGameReference<BattleGame> {
  EnemyManager({
    required super.position,
  })  : super(anchor: Anchor.center);

  var random = Random();

  int maxEnemies = 6;
  int enemyCount = 0;

  @override
  void onLoad() {
    spawner();
  }



  void spawnEnemy() {    
    var spawnDirection = 1;
    if (random.nextBool() == true) spawnDirection = 1;
    else spawnDirection = -1;

    game.world.add(Enemy(position: game.makePosition(750 * spawnDirection , random.nextDouble()*250 + 500)));    
    enemyCount++;
  }

  Future<void> spawner() async {
    while (enemyCount < maxEnemies) {
      spawnEnemy();
      await Future.delayed(Duration(seconds: 1 + random.nextInt(2)));
    }

  }




}