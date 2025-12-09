import 'dart:math';
import 'package:flutter/material.dart';

class SnowWidget extends StatefulWidget {
  final int flakes;
  const SnowWidget({Key? key, this.flakes = 20}) : super(key: key);

  @override
  State<SnowWidget> createState() => _SnowWidgetState();
}

class _SnowWidgetState extends State<SnowWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final Random _rnd = Random();
  final List<_Flake> _flakes = [];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
    for (int i = 0; i < widget.flakes; i++) {
      _flakes.add(_Flake(
        left: _rnd.nextDouble(),
        top: _rnd.nextDouble(),
        size: 4 + _rnd.nextDouble() * 8,
        speed: 1 + _rnd.nextDouble() * 2,
      ));
    }
    _ctrl.addListener(() {
      setState(() {
        for (var f in _flakes) {
          f.top += 0.001 * f.speed;
          if (f.top > 1) {
            f.top = 0;
            f.left = _rnd.nextDouble();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: _flakes.map((f) {
            return Positioned(
              left: f.left * constraints.maxWidth,
              top: f.top * constraints.maxHeight,
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  width: f.size,
                  height: f.size,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}

class _Flake {
  double left;
  double top;
  double size;
  double speed;
  _Flake({required this.left, required this.top, required this.size, required this.speed});
}
