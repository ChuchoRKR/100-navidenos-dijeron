import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../styles.dart';

class ResultPage extends StatelessWidget {
  final int totalPoints;
  final bool showOnly;
  const ResultPage({super.key, required this.totalPoints, this.showOnly = false});

  @override
  Widget build(BuildContext context) {
    final gp = Provider.of<GameProvider>(context);
    final red = gp.teamRed;
    final green = gp.teamGreen;
    String winner;
    if (red == green) winner = "Empate 🎁";
    else if (red > green) winner = "Gana Equipo Rojo 🎉";
    else winner = "Gana Equipo Verde 🎉";

    return Scaffold(
      appBar: AppBar(title: const Text("Resultados"), backgroundColor: XmasColors.red),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Resultados", style: XmasText.title),
            const SizedBox(height: 14),
            Text("Equipo Rojo: \$red pts", style: XmasText.subtitle.copyWith(color: XmasColors.red)),
            const SizedBox(height: 8),
            Text("Equipo Verde: \$green pts", style: XmasText.subtitle.copyWith(color: XmasColors.green)),
            const SizedBox(height: 18),
            Text(winner, style: XmasText.score),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: XmasColors.red),
              onPressed: () {
                gp.startGame();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("Volver al inicio"),
            )
          ]),
        ),
      ),
    );
  }
}
