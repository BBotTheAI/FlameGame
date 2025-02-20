import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';

import '../battle_game.dart';
import '../objects/bomb.dart';

class SkyManager extends PositionComponent with HasGameReference<BattleGame>{
  SkyManager({
    required super.position,
  }) : super(anchor: Anchor.center);
  
  var random = Random();

  @override
  FutureOr<void> onLoad() {
    makeItRain(1);
  }


  


  Future<void> makeItRain(int delaySecond) async {
    while(true) {
      
      game.world.add(new Bomb(position: game.makePosition(random.nextInt(900) - 450, (game.getPlayerPosition().y * -1) + 1000)));
      
  
      await Future.delayed(Duration(seconds: delaySecond)); 
    }
  }

  





















}