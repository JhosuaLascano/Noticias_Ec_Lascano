import 'package:flutter/material.dart';

/// Colores de la bandera del Ecuador.
class ColoresEC {
  static const amarillo = Color(0xFFFFD100);
  static const azul = Color(0xFF0033A0);
  static const rojo = Color(0xFFEF3340);
}

/// Tema claro y oscuro de la app, construidos a partir del azul de la bandera.
class AppTheme {
  static ThemeData claro() => _tema(Brightness.light);
  static ThemeData oscuro() => _tema(Brightness.dark);

  static ThemeData _tema(Brightness brillo) {
    final esquema = ColorScheme.fromSeed(
      seedColor: ColoresEC.azul,
      brightness: brillo,
    ).copyWith(secondary: ColoresEC.amarillo, tertiary: ColoresEC.rojo);
    final base = ThemeData(colorScheme: esquema, useMaterial3: true);
    final texto = base.textTheme;

    return base.copyWith(
      scaffoldBackgroundColor: esquema.surfaceContainerLowest,
      appBarTheme: AppBarTheme(
        backgroundColor: esquema.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      textTheme: texto.copyWith(
        headlineSmall: texto.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          height: 1.25,
        ),
        titleLarge: texto.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        titleMedium: texto.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        bodyLarge: texto.bodyLarge?.copyWith(height: 1.6),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: esquema.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: esquema.outlineVariant.withAlpha(110)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: const StadiumBorder(),
        side: BorderSide(color: esquema.outlineVariant),
        showCheckmark: false,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
