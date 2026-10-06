import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import '../models/noticia.dart';

/// Capa de acceso a datos: habla con la API REST y devuelve objetos Noticia.
class NewsService {
  // La clave se pasa al compilar: --dart-define=NEWS_API_KEY=tu_clave
  static const String _claveCompilada = String.fromEnvironment('NEWS_API_KEY');
  static const String _baseUrl = 'https://newsdata.io/api/1/latest';

  final String _apiKey;
  final http.Client _cliente;

  /// [apiKey] y [cliente] solo se pasan en las pruebas (MockClient).
  NewsService({String? apiKey, http.Client? cliente})
    : _apiKey = apiKey ?? _claveCompilada,
      _cliente = cliente ?? http.Client();

  /// Sin API key la app funciona en "modo demo" con un JSON local.
  bool get modoDemo => _apiKey.isEmpty;

  /// [busqueda] usa el parámetro q de la API (ejercicio "Buscador").
  Future<List<Noticia>> obtenerNoticias({
    String? categoria,
    String? busqueda,
  }) async {
    final q = (busqueda?.trim().isEmpty ?? true) ? null : busqueda!.trim();
    if (modoDemo) return _cargarDemo(categoria, q);

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'apikey': _apiKey,
        'country': 'ec',
        'language': 'es',
        'category': ?categoria,
        'q': ?q,
      },
    );

    final respuesta = await _cliente
        .get(uri)
        .timeout(const Duration(seconds: 15));
    if (respuesta.statusCode != 200) {
      throw Exception('Error ${respuesta.statusCode}: ${respuesta.body}');
    }
    return _parsear(utf8.decode(respuesta.bodyBytes));
  }

  List<Noticia> _parsear(String cuerpo) {
    final datos = jsonDecode(cuerpo) as Map<String, dynamic>;
    final resultados = datos['results'] as List<dynamic>? ?? [];
    return resultados
        .map((item) => Noticia.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Noticia>> _cargarDemo(String? categoria, String? q) async {
    final cuerpo = await rootBundle.loadString('assets/demo_noticias.json');
    var noticias = _parsear(cuerpo);
    if (categoria != null) {
      // La API acepta varias categorías separadas por coma.
      final buscadas = categoria.split(',');
      noticias = noticias
          .where((n) => n.categorias.any(buscadas.contains))
          .toList();
    }
    if (q != null) {
      final texto = q.toLowerCase();
      noticias = noticias
          .where(
            (n) =>
                n.titulo.toLowerCase().contains(texto) ||
                n.descripcion.toLowerCase().contains(texto),
          )
          .toList();
    }
    return noticias;
  }
}
