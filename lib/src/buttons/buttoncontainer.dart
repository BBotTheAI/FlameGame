import 'dart:async';

import 'package:flame/components.dart';

import '../../battle_game.dart';
import 'movebutton.dart';
import 'shootButton.dart';

class Buttoncontainer extends PositionComponent with HasGameReference<BattleGame>{
  Buttoncontainer({
    required super.position, required super.size,
  })  :super(anchor: Anchor.bottomCenter);

  
  late MoveButton _rightbutton;
  late MoveButton _leftbutton;
  late MoveButton _jumpbutton;
  late Shootbutton _shootButton;

  @override
  FutureOr<void> onLoad() {
    //debugMode = true;
    
    Vector2 buttonSizes = Vector2.all(size.y/2);
    double padding = buttonSizes.x;
    double edgePadding = padding/4;


    
    _leftbutton = MoveButton(position: Vector2(buttonSizes.x/2 + 10, size.y*2/3 + edgePadding), size: buttonSizes);
    _leftbutton.direction = -1;
    _leftbutton.rotateAngle = _leftbutton.degree90 * 2;
    add(_leftbutton);

    _rightbutton = MoveButton(position: Vector2(_leftbutton.position.x + buttonSizes.x + padding, size.y*2/3 + edgePadding), size: buttonSizes);
    _rightbutton.direction = 1;
    add(_rightbutton);

    _jumpbutton = MoveButton(position: Vector2(_leftbutton.position.x + buttonSizes.x/2 + padding/2, size.y/3 + edgePadding), size: buttonSizes);
    _jumpbutton.direction = 2;
    _jumpbutton.rotateAngle = _jumpbutton.degree90 * 3;
    add(_jumpbutton);

    _shootButton = Shootbutton(size: Vector2.all(size.y));
    _shootButton.position = Vector2(size.x -_shootButton.size.x/2 - edgePadding , size.y/2);
    add(_shootButton);
    
  }


  void disableButtons() {
    remove(_shootButton);
    remove(_jumpbutton);
    remove(_rightbutton);
    remove(_leftbutton);
  }

  
}