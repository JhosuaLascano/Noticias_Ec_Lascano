import 'package:flutter/material.dart';

import '../models/noticia.dart';
import '../services/favoritos_service.dart';
import '../widgets/estados.dart';
import '../widgets/tarjeta_noticia.dart';
import 'detalle_screen.dart';

/// Tercera pantalla: noticias guardadas localmente con shared_preferences.
class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final FavoritosService _servicio = FavoritosService();
  late Future<List<Noticia>> _futuroFavoritos;

  @override
  void initState() {
    super.initState();
    _futuroFavoritos = _servicio.obtener();
  }

  Future<void> _abrir(Noticia noticia) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalleScreen(noticia: noticia)),
    );
    // Al volver se recarga por si el usuario quitó la noticia de favoritos.
    setState(() => _futuroFavoritos = _servicio.obtener());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        bottom: const FranjaBandera(),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: FutureBuilder<List<Noticia>>(
            future: _futuroFavoritos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ListaEsqueleto();
              }
              final favoritos = snapshot.data ?? [];
              if (favoritos.isEmpty) {
                return const MensajeEstado(
                  icono: Icons.bookmark_border_rounded,
                  titulo: 'Aún no guardas noticias',
                  detalle: 'Abre una noticia y toca el marcador para guardarla aquí.',
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: favoritos.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) => TarjetaNoticia(
                  noticia: favoritos[i],
                  onTap: () => _abrir(favoritos[i]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
