import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

import '../../battle_game.dart';

class Enemynumtext extends TextComponent with HasGameReference<BattleGame>{
  Enemynumtext({
    required super.position
  }) :super(anchor: Anchor.topLeft, text: "Remaining enemies: "); 






  @override
  FutureOr<void> onLoad() {

    TextStyle regularStyle = TextStyle(fontSize: game.calculateSizeDouble(48), color: BasicPalette.white.color);

    TextPaint regular = TextPaint(style: regularStyle);

    textRenderer = regular;
  }









}