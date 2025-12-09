import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../styles.dart';
import 'result_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late AudioPlayer _bgPlayer;
  late AudioCache _cache;
  @override
  void initState() {
    super.initState();
    _bgPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.loop);
    _cache = AudioCache(prefix: 'assets/sounds/');
    // start background if exists
    _playBackground();
    // start timer via provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameProvider>(context, listen: false).startTimer(seconds: 20);
    });
  }

  Future<void> _playBackground() async {
    try {
      final file = await _cache.loadAsFile('background.mp3');
      await _bgPlayer.play(DeviceFileSource(file.path), volume: 0.2);
    } catch (_) {
      // asset missing -> ignore
    }
  }

  Future<void> _playSuccess() async {
    try {
      await _cache.play('success.mp3');
    } catch (_) {}
  }

  @override
  void dispose() {
    _bgPlayer.stop();
    _bgPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, gp, _) {
      if (gp.index >= gp.totalQuestions) {
        // finished
        Future.microtask(() {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultPage(totalPoints: gp.teamRed > gp.teamGreen ? gp.teamRed : gp.teamGreen)));
        });
      }

      final q = gp.currentQuestion;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: XmasColors.red,
          title: Text("Pregunta ${gp.index + 1} / ${gp.totalQuestions}"),
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(child: Text(gp.isRedTurn ? "Turno: Rojo" : "Turno: Verde", style: const TextStyle(fontWeight: FontWeight.bold))),
            )
          ],
        ),
        body: Stack(
          children: [
            Container(color: XmasColors.bg),
            Positioned.fill(child: Opacity(opacity: 0.9, child: Image.asset('assets/images/tree_bg.png', fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox()))),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Text(q.text, style: XmasText.question, textAlign: TextAlign.center),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Rojo: \${gp.teamRed}", style: XmasText.subtitle.copyWith(color: XmasColors.red)),
                              Row(children: [
                                const Icon(Icons.timer, size: 20),
                                const SizedBox(width: 6),
                                Text("\${gp.remainingSeconds}s", style: XmasText.subtitle),
                              ]),
                              Text("Verde: \${gp.teamGreen}", style: XmasText.subtitle.copyWith(color: XmasColors.green)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: ListView.builder(
                      itemCount: q.answers.length,
                      itemBuilder: (context, i) {
                        final a = q.answers[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gp.isRedTurn ? XmasColors.red.withOpacity(0.9) : XmasColors.green.withOpacity(0.9),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () async {
                              await _playSuccess();
                              gp.addScore(a.points);
                              if (gp.isLast) {
                                // go to results
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultPage(totalPoints: gp.teamRed > gp.teamGreen ? gp.teamRed : gp.teamGreen)));
                              } else {
                                gp.nextTurn();
                                gp.startTimer(seconds: 20);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(a.text, style: XmasText.answer),
                                Text("\${a.points} pts", style: XmasText.answer),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        onPressed: () {
                          // skip / reveal 0
                          if (gp.isLast) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultPage(totalPoints: gp.teamRed > gp.teamGreen ? gp.teamRed : gp.teamGreen)));
                          } else {
                            gp.nextTurn();
                            gp.startTimer(seconds: 20);
                          }
                        },
                        child: const Text("Saltar"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: XmasColors.dark),
                        onPressed: () {
                          // toggle team
                          if (!gp.isLast) {
                            gp.nextTurn();
                            gp.startTimer(seconds: 20);
                          }
                        },
                        child: const Text("Terminar turno"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
