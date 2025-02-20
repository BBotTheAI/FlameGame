import 'package:flame/components.dart';

class Healthtext extends TextComponent {
  Healthtext({
    required super.position, super.size
  }) :super(anchor: Anchor.topLeft, text: "Health: "); 
}