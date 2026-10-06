import 'package:flutter/material.dart';

import '../models/noticia.dart';
import '../utils/fechas.dart';
import 'categorias.dart';
import 'imagen_noticia.dart';

/// Tarjeta compacta (miniatura a la izquierda), usada en la lista principal
/// y en la de favoritos.
class TarjetaNoticia extends StatelessWidget {
  final Noticia noticia;
  final VoidCallback onTap;

  const TarjetaNoticia({super.key, required this.noticia, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ImagenNoticia(
                  noticia: noticia,
                  width: 96,
                  height: 96,
                  tamanoIcono: 32,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EtiquetaCategoria(info: categoriaPrincipal(noticia)),
                    const SizedBox(height: 6),
                    Text(
                      noticia.titulo,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: tema.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    LineaFuente(noticia: noticia),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Primera noticia de la lista: imagen grande con el titular encima.
class TarjetaDestacada extends StatelessWidget {
  final Noticia noticia;
  final VoidCallback onTap;

  const TarjetaDestacada({
    super.key,
    required this.noticia,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: AspectRatio(
          // Más alta en teléfonos para que el titular no tape la imagen.
          aspectRatio: MediaQuery.sizeOf(context).width < 500
              ? 4 / 3.6
              : 16 / 10,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ImagenNoticia(noticia: noticia, tamanoIcono: 72),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.25, 1],
                    colors: [Colors.transparent, Color(0xE6000000)],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EtiquetaCategoria(
                      info: categoriaPrincipal(noticia),
                      sobreImagen: true,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      noticia.titulo,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(color: Colors.white, height: 1.25),
                    ),
                    const SizedBox(height: 8),
                    LineaFuente(noticia: noticia, sobreImagen: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo del medio + nombre + "Hace X h".
class LineaFuente extends StatelessWidget {
  final Noticia noticia;
  final bool sobreImagen;
  final bool fechaCompletaVisible;

  const LineaFuente({
    super.key,
    required this.noticia,
    this.sobreImagen = false,
    this.fechaCompletaVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final color = sobreImagen
        ? Colors.white70
        : tema.colorScheme.onSurfaceVariant;
    final estilo = tema.textTheme.bodySmall?.copyWith(color: color);
    final fecha = fechaCompletaVisible
        ? fechaCompleta(noticia.fecha)
        : haceCuanto(noticia.fecha);

    return Row(
      children: [
        _LogoFuente(noticia: noticia),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            noticia.fuente,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: estilo?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        if (fecha.isNotEmpty) Text('  ·  $fecha', style: estilo),
      ],
    );
  }
}

class _LogoFuente extends StatelessWidget {
  final Noticia noticia;

  const _LogoFuente({required this.noticia});

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final inicial = Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      color: esquema.primaryContainer,
      child: Text(
        noticia.fuente.isEmpty ? '?' : noticia.fuente[0].toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: esquema.onPrimaryContainer,
        ),
      ),
    );
    return ClipOval(
      child: noticia.fuenteIcono == null
          ? inicial
          : Image.network(
              noticia.fuenteIcono!,
              width: 18,
              height: 18,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => inicial,
            ),
    );
  }
}
