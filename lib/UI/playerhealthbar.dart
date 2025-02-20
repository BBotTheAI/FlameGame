import 'dart:ui';

import 'package:flame/components.dart';

class Playerhealthbar extends RectangleComponent {
  Playerhealthbar({required super.position, required super.size})  
    :super(
      anchor: Anchor.center,
      paint: Paint()
        ..color = Color.fromRGBO(0, 0, 0, 100)
        ..style = PaintingStyle.fill

      
  );

  List<RectangleComponent> recList = [];
  bool firstRemoved = false;
  bool secondRemoved = false;
  bool thirdRemoved = false;

  @override
  void onLoad() {
    debugMode = false;


    for(int i = (size.y - (size.x/2)).toInt(); i > 0; i-= (size.y/4).toInt()) {
      recList.add(new RectangleComponent(
        size: Vector2(size.x, size.y/4),
        position: Vector2(size.x/2, i.toDouble()),
        anchor: Anchor.center,
        paint: Paint()
          ..style = PaintingStyle.fill
      ));
    }

    for (int i = 0; i < recList.length; i++) {
      add(recList[i]);
    }
    

    
  }

  void updateBar(int health) {    

    if (health >= 80) {
      
      updateColors(Color.fromARGB(255, 81, 255, 0));
      
    }
    else if (health >= 60) {

      if(!firstRemoved) {
        remove(recList.last);
        recList.removeLast();
        firstRemoved = true;
      }
      
      updateColors(Color.fromARGB(255, 247, 255, 16));

    }
    else if (health >= 40) {

      if(!secondRemoved) {
        remove(recList.last);
        recList.removeLast();
        secondRemoved = true;
      }

      updateColors(Color.fromARGB(255, 237, 130, 0));

    }
    else {

      if(!thirdRemoved) {
        remove(recList.last);
        recList.removeLast();
        thirdRemoved = true;
      }

      updateColors(Color.fromARGB(255, 237, 0, 0));
    }
    
  }


  void updateColors(Color newColor) {

    for (int i = 0; i < recList.length; i++) {
      if(recList.isNotEmpty)  recList[i].paint.color = newColor;
    }

  }
  
}






