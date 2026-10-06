import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/noticia.dart';
import '../services/favoritos_service.dart';
import '../widgets/categorias.dart';
import '../widgets/imagen_noticia.dart';
import '../widgets/tarjeta_noticia.dart';

class DetalleScreen extends StatefulWidget {
  final Noticia noticia;

  const DetalleScreen({super.key, required this.noticia});

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  final FavoritosService _favoritos = FavoritosService();
  bool _esFavorito = false;

  Noticia get noticia => widget.noticia;

  @override
  void initState() {
    super.initState();
    _favoritos.esFavorito(noticia.id).then((valor) {
      if (mounted) setState(() => _esFavorito = valor);
    });
  }

  Future<void> _alternarFavorito() async {
    final valor = await _favoritos.alternar(noticia);
    if (!mounted) return;
    setState(() => _esFavorito = valor);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(valor ? 'Agregada a favoritos' : 'Quitada de favoritos'),
      ),
    );
  }

  Future<void> _abrirEnlace(BuildContext context) async {
    final uri = Uri.parse(noticia.enlace);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: 300,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton.filledTonal(
                tooltip: 'Volver',
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              IconButton.filledTonal(
                tooltip: _esFavorito
                    ? 'Quitar de favoritos'
                    : 'Guardar en favoritos',
                icon: Icon(
                  _esFavorito
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                ),
                onPressed: _alternarFavorito,
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ImagenNoticia(noticia: noticia, tamanoIcono: 96),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0, 0.3, 0.75, 1],
                        colors: [
                          Color(0x66000000),
                          Colors.transparent,
                          Colors.transparent,
                          Color(0x55000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: noticia.categorias
                            .map(
                              (c) => EtiquetaCategoria(info: infoCategoria(c)),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      Text(noticia.titulo, style: tema.textTheme.headlineSmall),
                      const SizedBox(height: 14),
                      LineaFuente(noticia: noticia, fechaCompletaVisible: true),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(height: 1),
                      ),
                      Text(
                        noticia.descripcion.isEmpty
                            ? 'Esta noticia no tiene descripción.'
                            : noticia.descripcion,
                        style: tema.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () => _abrirEnlace(context),
                          icon: const Icon(Icons.open_in_new_rounded),
                          label: const Text('Leer noticia completa'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
