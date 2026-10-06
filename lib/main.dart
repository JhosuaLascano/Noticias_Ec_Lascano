import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const NoticiasApp());
}

class NoticiasApp extends StatefulWidget {
  const NoticiasApp({super.key});

  @override
  State<NoticiasApp> createState() => _NoticiasAppState();
}

class _NoticiasAppState extends State<NoticiasApp> {
  ThemeMode _modoTema = ThemeMode.light;

  void _alternarTema() {
    setState(() {
      _modoTema = _modoTema == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noticias EC Lascano Jhosua',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro(),
      darkTheme: AppTheme.oscuro(),
      themeMode: _modoTema,
      home: HomeScreen(
        modoOscuro: _modoTema == ThemeMode.dark,
        onAlternarTema: _alternarTema,
      ),
    );
  }
}
