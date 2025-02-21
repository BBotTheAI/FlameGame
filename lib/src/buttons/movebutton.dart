import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../../battle_game.dart';

class MoveButton extends PositionComponent with TapCallbacks, HasGameReference<BattleGame>{
  MoveButton({
    required super.position, required super.size,
  })  :super(
        anchor: Anchor.center,
  );

  final _paint = Paint()..color = const Color.fromRGBO(255, 255, 255, 100);
  late double radius;
  double degree90 = 1.571;
  double rotateAngle = 0;
  int direction = 0;

  @override
  FutureOr<void> onLoad() {
    radius = size.y/2;
    angle += rotateAngle;
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.moveDirection = direction;   
  }

  @override
  void onTapUp( event) {
    game.moveDirection = 0;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    game.moveDirection = 0;
  }



  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(size.x/2, size.y/2), radius, _paint);
    
    Rect rect = Rect.fromCenter(center: Offset(size.x/2 - radius/4, size.y/2), width: radius, height: radius/2);
    final rectPaint = Paint()..color = const Color.fromARGB(255, 0, 0, 0);
    canvas.drawRect(rect, rectPaint);

    canvas.drawPath(getTrianglePath(Vector2(size.x/2, size.y/2), radius* (3/4), radius/2), rectPaint);


    

  }

  

  Path getTrianglePath(Vector2 origin, double x, double y) {
    return Path()
      ..moveTo(origin.x, origin.y + y)
      ..lineTo(origin.x + x, origin.y)
      ..lineTo(origin.x, origin.y - y)
      ..lineTo(origin.x, origin.y + y);
  }
  
}

