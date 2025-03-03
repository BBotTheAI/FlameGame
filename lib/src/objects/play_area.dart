import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/battle_game.dart';

class PlayArea extends RectangleComponent with HasGameReference<BattleGame> {
  PlayArea()  : super(
    paint: Paint()..color = const Color(0xfff2e8cf),
    children: [RectangleHitbox()],
  );


  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.size.x, game.size.y);
  }


}