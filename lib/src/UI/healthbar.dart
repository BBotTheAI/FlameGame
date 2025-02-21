import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../battle_game.dart';

class Healthbar extends RectangleComponent with HasGameReference<BattleGame>{
  Healthbar({required super.position})  
    :super(
      anchor: Anchor.bottomLeft,
      paint: Paint()
        ..color = Color.fromARGB(255, 255, 255, 255)
        ..style = PaintingStyle.fill
  );

  Color color = Color.fromARGB(255, 255, 255, 255);

  @override
  FutureOr<void> onLoad() {
    double newSize = game.calculateSizeDouble(50);
    size = Vector2(newSize, newSize/10);
    
  }
 


  void updateColor(int health) {
    if (health > 75) color = Color.fromARGB(255, 81, 255, 0);
    else if (health > 50) color = Color.fromARGB(255, 247, 255, 16);
    else if (health > 25) color = Color.fromARGB(255, 237, 130, 0);
    else color = Color.fromARGB(255, 237, 0, 0);

    paint.color = color;
  }

  void chooseColor(Color newColor) {
    paint.color = newColor;
  }
  
}






