import 'package:flutter/material.dart';

import '../models/noticia.dart';
import 'categorias.dart';

/// Imagen de la noticia. Si no tiene, todavía carga o el medio la bloquea,
/// muestra un fondo con el color e ícono de su categoría.
class ImagenNoticia extends StatelessWidget {
  final Noticia noticia;
  final double? width;
  final double? height;
  final double tamanoIcono;

  const ImagenNoticia({
    super.key,
    required this.noticia,
    this.width,
    this.height,
    this.tamanoIcono = 40,
  });

  @override
  Widget build(BuildContext context) {
    final respaldo = _Respaldo(
      info: categoriaPrincipal(noticia),
      width: width,
      height: height,
      tamanoIcono: tamanoIcono,
    );
    if (noticia.imagenUrl == null) return respaldo;

    return Image.network(
      noticia.imagenUrl!,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (_, imagen, progreso) =>
          progreso == null ? imagen : respaldo,
      errorBuilder: (_, _, _) => respaldo,
    );
  }
}

class _Respaldo extends StatelessWidget {
  final InfoCategoria info;
  final double? width;
  final double? height;
  final double tamanoIcono;

  const _Respaldo({
    required this.info,
    required this.width,
    required this.height,
    required this.tamanoIcono,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [info.color.withAlpha(60), info.color.withAlpha(130)],
        ),
      ),
      child: Icon(info.icono, size: tamanoIcono, color: Colors.white),
    );
  }
}
