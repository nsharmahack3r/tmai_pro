import 'package:flutter/material.dart';
import 'package:tmai_pro/src/resource/themes.dart';
import 'package:tmai_pro/src/router.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ApplicationThemes.light,
      darkTheme: ApplicationThemes.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      title: 'TMAI Pro',
      routerConfig: router,
    );
  }
}
