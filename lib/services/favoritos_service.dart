import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/noticia.dart';

/// Guarda las noticias favoritas en el almacenamiento local del dispositivo.
class FavoritosService {
  static const String _clave = 'favoritos';

  Future<List<Noticia>> obtener() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(_clave) ?? [];
    return lista
        .map((s) => Noticia.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<bool> esFavorito(String id) async {
    final favoritos = await obtener();
    return favoritos.any((n) => n.id == id);
  }

  /// Agrega o quita la noticia. Devuelve true si quedó como favorita.
  Future<bool> alternar(Noticia noticia) async {
    final favoritos = await obtener();
    final existe = favoritos.any((n) => n.id == noticia.id);
    if (existe) {
      favoritos.removeWhere((n) => n.id == noticia.id);
    } else {
      favoritos.insert(0, noticia);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _clave,
      favoritos.map((n) => jsonEncode(n.toJson())).toList(),
    );
    return !existe;
  }
}
