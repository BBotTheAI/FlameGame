import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'battle_game.dart';
import 'src/widgets/game_app.dart';

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    
    runApp(const GameApp());
    
    
    
    /*
    runApp(
      
      const GameWidget<BattleGame>.controlled(
        gameFactory: BattleGame.new,
      ),
    );
    */

  });
  
  
  
  
  
  
  
  
}