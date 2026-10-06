import 'package:flutter/material.dart';

import '../models/noticia.dart';

/// Cómo se ve cada categoría de la API en la interfaz.
class InfoCategoria {
  final String etiqueta;
  final IconData icono;
  final Color color;

  const InfoCategoria(this.etiqueta, this.icono, this.color);
}

/// Categorías que se muestran como filtros (valor de la API -> apariencia).
const Map<String, InfoCategoria> categoriasFiltro = {
  'education': InfoCategoria(
    'Educación',
    Icons.school_rounded,
    Color(0xFF5C6BC0),
  ),
  'politics': InfoCategoria(
    'Política',
    Icons.account_balance_rounded,
    Color(0xFF0033A0),
  ),
  'technology': InfoCategoria(
    'Tecnología',
    Icons.memory_rounded,
    Color(0xFF00897B),
  ),
  'tourism': InfoCategoria(
    'Turismo',
    Icons.landscape_rounded,
    Color(0xFF43A047),
  ),
  'crime': InfoCategoria(
    'Crimen',
    Icons.local_police_rounded,
    Color(0xFFEF3340),
  ),
};

/// Otras categorías que la API puede devolver junto a las anteriores.
const Map<String, String> _otrasEtiquetas = {
  'top': 'Destacado',
  'domestic': 'Nacional',
  'world': 'Mundo',
  'business': 'Economía',
  'sports': 'Deportes',
  'entertainment': 'Entretenimiento',
  'health': 'Salud',
  'science': 'Ciencia',
  'environment': 'Ambiente',
  'lifestyle': 'Estilo de vida',
  'food': 'Gastronomía',
  'other': 'Otros',
};

const _general = InfoCategoria(
  'Noticias',
  Icons.newspaper_rounded,
  Color(0xFF607D8B),
);

InfoCategoria infoCategoria(String clave) =>
    categoriasFiltro[clave] ??
    InfoCategoria(
      _otrasEtiquetas[clave] ?? clave,
      _general.icono,
      _general.color,
    );

/// La categoría que mejor describe la noticia: primero una de los filtros.
InfoCategoria categoriaPrincipal(Noticia noticia) {
  for (final c in noticia.categorias) {
    if (categoriasFiltro.containsKey(c)) return categoriasFiltro[c]!;
  }
  return noticia.categorias.isEmpty
      ? _general
      : infoCategoria(noticia.categorias.first);
}

/// Etiqueta pequeña de color con el nombre de la categoría.
class EtiquetaCategoria extends StatelessWidget {
  final InfoCategoria info;
  final bool sobreImagen;

  const EtiquetaCategoria({
    super.key,
    required this.info,
    this.sobreImagen = false,
  });

  @override
  Widget build(BuildContext context) {
    // En modo oscuro se aclara el texto para que se lea sobre fondo oscuro.
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    final colorTexto = oscuro
        ? Color.lerp(info.color, Colors.white, 0.55)!
        : info.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: sobreImagen
            ? info.color
            : info.color.withAlpha(oscuro ? 70 : 30),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        info.etiqueta.toUpperCase(),
        style: TextStyle(
          color: sobreImagen ? Colors.white : colorTexto,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
