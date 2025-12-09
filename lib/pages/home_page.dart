import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../styles.dart';
import '../providers/game_provider.dart';
import 'game_page.dart';
import 'add_question_page.dart';
import 'result_page.dart';
import '../widgets/snow_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final gp = Provider.of<GameProvider>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          Container(color: XmasColors.bg),
          const SnowWidget(flakes: 30),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("🎄 100 Navideños Dijeron", style: XmasText.title, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Text("Diviértete con tu familia — equipo rojo vs verde", style: XmasText.subtitle, textAlign: TextAlign.center),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: XmasColors.red, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)),
                      onPressed: () {
                        gp.startGame();
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const GamePage()));
                      },
                      child: Text("Comenzar juego", style: XmasText.subtitle.copyWith(color: Colors.white)),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: XmasColors.green, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AddQuestionPage()));
                      },
                      child: Text("Agregar pregunta personalizada", style: XmasText.subtitle.copyWith(color: Colors.white)),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ResultPage(totalPoints: 0, showOnly: true)));
                      },
                      child: Text("Ver resultados (demo)", style: XmasText.subtitle.copyWith(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
