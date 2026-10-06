import 'package:flutter_test/flutter_test.dart';
import 'package:noticias_ec/models/noticia.dart';

void main() {
  test('Noticia.fromJson convierte el JSON de NewsData.io', () {
    final noticia = Noticia.fromJson({
      'article_id': 'abc',
      'title': 'Titular',
      'link': 'https://ejemplo.ec',
      'description': null,
      'pubDate': '2026-10-05 08:30:00',
      'image_url': null,
      'source_id': 'eluniverso',
      'category': ['politics'],
    });
    expect(noticia.titulo, 'Titular');
    expect(noticia.descripcion, '');
    expect(noticia.fuente, 'eluniverso');
    expect(noticia.fecha?.year, 2026);
    expect(noticia.categorias, ['politics']);
  });

  test('toJson y fromJson son inversos (favoritos)', () {
    final original = Noticia.fromJson({
      'article_id': 'x1',
      'title': 'Año nuevo en Cuenca',
      'link': 'https://ejemplo.ec',
      'pubDate': '2026-10-05 08:30:00',
      'source_name': 'El Mercurio',
      'category': ['top'],
    });
    final copia = Noticia.fromJson(original.toJson());
    expect(copia.id, original.id);
    expect(copia.titulo, original.titulo);
    expect(copia.fecha, original.fecha);
    expect(copia.categorias, original.categorias);
  });
}
