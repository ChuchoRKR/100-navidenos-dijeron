import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'styles.dart';
import 'providers/game_provider.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const NavidadApp());
}

class NavidadApp extends StatelessWidget {
  const NavidadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '100 Navideños Dijeron',
        theme: ThemeData(
          primaryColor: XmasColors.red,
          scaffoldBackgroundColor: XmasColors.bg,
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
