import 'package:flutter_test/flutter_test.dart';
import 'package:noticias_ec/models/noticia.dart';
import 'package:noticias_ec/utils/fechas.dart';

void main() {
  test('pubDate se interpreta como UTC', () {
    final noticia = Noticia.fromJson({'pubDate': '2026-10-05 21:47:53'});
    expect(noticia.fecha!.toUtc(), DateTime.utc(2026, 10, 5, 21, 47, 53));
  });

  test('haceCuanto da textos relativos', () {
    final ahora = DateTime(2026, 10, 6, 12);
    expect(haceCuanto(null), '');
    expect(haceCuanto(ahora, ahora: ahora), 'Ahora');
    expect(
      haceCuanto(ahora.subtract(const Duration(minutes: 5)), ahora: ahora),
      'Hace 5 min',
    );
    expect(
      haceCuanto(ahora.subtract(const Duration(hours: 3)), ahora: ahora),
      'Hace 3 h',
    );
    expect(
      haceCuanto(ahora.subtract(const Duration(days: 2)), ahora: ahora),
      'Hace 2 d',
    );
    expect(haceCuanto(DateTime(2026, 9, 1), ahora: ahora), '01/09/2026');
  });
}
