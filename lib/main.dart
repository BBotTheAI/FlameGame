import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'battle_game.dart';

void main() {
  runApp(
    const GameWidget<BattleGame>.controlled(
      gameFactory: BattleGame.new,
    ),
  );
}