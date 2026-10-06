import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:noticias_ec/services/news_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final respuestaOk = jsonEncode({
    'status': 'success',
    'results': [
      {
        'article_id': '1',
        'title': 'Inauguran puente en Tulcán',
        'link': 'https://ejemplo.ec/1',
        'pubDate': '2026-10-05 08:30:00',
        'source_name': 'Diario del Norte',
        'category': ['top'],
      },
    ],
  });

  test('arma la URL con country, language, category y q', () async {
    late Uri pedida;
    final cliente = MockClient((request) async {
      pedida = request.url;
      return http.Response.bytes(utf8.encode(respuestaOk), 200);
    });
    final servicio = NewsService(apiKey: 'clave-prueba', cliente: cliente);

    final noticias = await servicio.obtenerNoticias(
      categoria: 'education,politics',
      busqueda: ' quito ',
    );

    expect(pedida.host, 'newsdata.io');
    expect(pedida.path, '/api/1/latest');
    expect(pedida.queryParameters, {
      'apikey': 'clave-prueba',
      'country': 'ec',
      'language': 'es',
      'category': 'education,politics',
      'q': 'quito',
    });
    expect(noticias, hasLength(1));
    expect(noticias.first.titulo, 'Inauguran puente en Tulcán'); // UTF-8 ok
  });

  test('omite category y q cuando no se envían', () async {
    late Uri pedida;
    final cliente = MockClient((request) async {
      pedida = request.url;
      return http.Response.bytes(utf8.encode(respuestaOk), 200);
    });
    await NewsService(apiKey: 'k', cliente: cliente).obtenerNoticias();

    expect(pedida.queryParameters.containsKey('category'), isFalse);
    expect(pedida.queryParameters.containsKey('q'), isFalse);
  });

  test('lanza Exception si la API responde 401', () async {
    final cliente = MockClient(
      (_) async => http.Response('{"status":"error"}', 401),
    );
    final servicio = NewsService(apiKey: 'mala', cliente: cliente);

    expect(servicio.obtenerNoticias(), throwsA(isA<Exception>()));
  });

  test('sin API key usa el JSON de demo y filtra por categoría', () async {
    final servicio = NewsService(apiKey: '');
    expect(servicio.modoDemo, isTrue);

    final turismo = await servicio.obtenerNoticias(categoria: 'tourism');
    expect(turismo, isNotEmpty);
    expect(turismo.every((n) => n.categorias.contains('tourism')), isTrue);

    final varias = await servicio.obtenerNoticias(categoria: 'crime,education');
    expect(varias, hasLength(2));
  });
}
