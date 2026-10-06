import 'package:flutter/material.dart';

import '../models/noticia.dart';
import '../services/news_service.dart';
import '../theme/app_theme.dart';
import '../widgets/categorias.dart';
import '../widgets/estados.dart';
import '../widgets/tarjeta_noticia.dart';
import 'detalle_screen.dart';
import 'favoritos_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool modoOscuro;
  final VoidCallback onAlternarTema;

  const HomeScreen({
    super.key,
    required this.modoOscuro,
    required this.onAlternarTema,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _servicio = NewsService();
  final TextEditingController _busquedaCtrl = TextEditingController();
  late Future<List<Noticia>> _futuroNoticias;
  String? _categoria; // null = todas
  String? _busqueda; // null = sin filtro de texto
  bool _buscando = false; // muestra el TextField en el AppBar

  // "Todas" pide las cinco categorías juntas: category=education,politics,...
  static final String _todasLasCategorias = categoriasFiltro.keys.join(',');

  /// Ancho máximo del contenido para que en web/escritorio no se estire.
  static const double _anchoMaximo = 760;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  void _cargar() {
    _futuroNoticias = _servicio.obtenerNoticias(
      categoria: _categoria ?? _todasLasCategorias,
      busqueda: _busqueda,
    );
  }

  Future<void> _refrescar() async {
    setState(_cargar);
    await _futuroNoticias;
  }

  void _buscar(String texto) {
    setState(() {
      _busqueda = texto.trim().isEmpty ? null : texto.trim();
      _cargar();
    });
  }

  void _cerrarBusqueda() {
    _busquedaCtrl.clear();
    setState(() {
      _buscando = false;
      if (_busqueda != null) {
        _busqueda = null;
        _cargar();
      }
    });
  }

  void _abrir(Noticia noticia) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalleScreen(noticia: noticia)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        titleSpacing: 16,
        title: _buscando ? _campoBusqueda() : _marca(),
        actions: [
          IconButton(
            tooltip: _buscando ? 'Cerrar búsqueda' : 'Buscar',
            icon: Icon(_buscando ? Icons.close_rounded : Icons.search_rounded),
            onPressed: _buscando
                ? _cerrarBusqueda
                : () => setState(() => _buscando = true),
          ),
          if (!_buscando) ...[
            IconButton(
              tooltip: 'Favoritos',
              icon: const Icon(Icons.bookmarks_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritosScreen()),
              ),
            ),
            IconButton(
              tooltip: widget.modoOscuro ? 'Modo claro' : 'Modo oscuro',
              icon: Icon(
                widget.modoOscuro
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
              ),
              onPressed: widget.onAlternarTema,
            ),
          ],
          const SizedBox(width: 8),
        ],
        bottom: const FranjaBandera(),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _anchoMaximo),
          child: Column(
            children: [
              _barraCategorias(),
              Expanded(child: _listaNoticias()),
            ],
          ),
        ),
      ),
    );
  }

  /// Logotipo: "Noticias EC" con el nombre del autor debajo.
  Widget _marca() {
    final tema = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ColoresEC.azul,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.newspaper_rounded,
            color: ColoresEC.amarillo,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Noticias EC',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tema.textTheme.titleLarge,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'Lascano Jhosua',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tema.textTheme.labelMedium?.copyWith(
                        color: tema.colorScheme.onSurfaceVariant,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  // La etiqueta DEMO va en esta línea porque en teléfonos
                  // no cabe junto al título.
                  if (_servicio.modoDemo) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: ColoresEC.amarillo,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'DEMO',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _campoBusqueda() {
    return TextField(
      controller: _busquedaCtrl,
      autofocus: true,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Buscar noticias (ej. quito)',
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        isDense: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmitted: _buscar,
    );
  }

  Widget _barraCategorias() {
    final esquema = Theme.of(context).colorScheme;
    final opciones = <String?, InfoCategoria>{
      null: InfoCategoria('Todas', Icons.apps_rounded, esquema.primary),
      ...categoriasFiltro,
    };
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        children: opciones.entries.map((e) {
          final seleccionada = _categoria == e.key;
          final info = e.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              avatar: Icon(
                info.icono,
                size: 18,
                color: seleccionada ? Colors.white : info.color,
              ),
              label: Text(info.etiqueta),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: seleccionada ? Colors.white : null,
              ),
              selected: seleccionada,
              selectedColor: info.color,
              side: seleccionada ? BorderSide.none : null,
              onSelected: (_) => setState(() {
                _categoria = e.key;
                _cargar();
              }),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _listaNoticias() {
    return FutureBuilder<List<Noticia>>(
      future: _futuroNoticias,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListaEsqueleto();
        }
        if (snapshot.hasError) {
          return MensajeEstado(
            icono: Icons.cloud_off_rounded,
            titulo: 'No se pudieron cargar las noticias',
            detalle: '${snapshot.error}',
            onBoton: () => setState(_cargar),
          );
        }
        final noticias = snapshot.data ?? [];
        if (noticias.isEmpty) {
          return MensajeEstado(
            icono: Icons.inbox_rounded,
            titulo: _busqueda == null
                ? 'No hay noticias en esta categoría'
                : 'No hay resultados para "$_busqueda"',
            onBoton: () => setState(_cargar),
          );
        }
        return RefreshIndicator(
          onRefresh: _refrescar,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            itemCount: noticias.length + (noticias.length > 1 ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              if (i == 0) {
                return TarjetaDestacada(
                  noticia: noticias[0],
                  onTap: () => _abrir(noticias[0]),
                );
              }
              if (i == 1) return _tituloSeccion('Más noticias');
              final noticia = noticias[i - 1];
              return TarjetaNoticia(
                noticia: noticia,
                onTap: () => _abrir(noticia),
              );
            },
          ),
        );
      },
    );
  }

  Widget _tituloSeccion(String texto) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: ColoresEC.rojo,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(texto, style: tema.textTheme.titleMedium),
        ],
      ),
    );
  }
}
