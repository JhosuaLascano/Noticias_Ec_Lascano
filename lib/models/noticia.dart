/// Representa una noticia tal como la devuelve la API de NewsData.io.
class Noticia {
  final String id;
  final String titulo;
  final String descripcion;
  final String enlace;
  final String? imagenUrl;
  final String fuente;
  final String? fuenteIcono;
  final DateTime? fecha;
  final List<String> categorias;

  const Noticia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.enlace,
    required this.imagenUrl,
    required this.fuente,
    this.fuenteIcono,
    required this.fecha,
    required this.categorias,
  });

  /// Convierte un objeto JSON (Map) en una Noticia.
  /// Cada campo puede venir null, por eso usamos valores por defecto.
  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['article_id'] as String? ?? '',
      titulo: json['title'] as String? ?? 'Sin título',
      descripcion: json['description'] as String? ?? '',
      enlace: json['link'] as String? ?? '',
      imagenUrl: json['image_url'] as String?,
      fuente:
          json['source_name'] as String? ??
          json['source_id'] as String? ??
          'Desconocida',
      fuenteIcono: json['source_icon'] as String?,
      fecha: _fechaUtc(json['pubDate'] as String?),
      categorias: (json['category'] as List<dynamic>? ?? [])
          .map((c) => c.toString())
          .toList(),
    );
  }

  /// NewsData.io envía pubDate en UTC sin indicarlo en el texto
  /// ("2026-10-05 21:47:53"), así que lo marcamos como UTC y lo pasamos
  /// a la hora local del dispositivo (Ecuador = UTC-5).
  static DateTime? _fechaUtc(String? texto) {
    final f = DateTime.tryParse(texto ?? '');
    if (f == null) return null;
    final utc = f.isUtc
        ? f
        : DateTime.utc(f.year, f.month, f.day, f.hour, f.minute, f.second);
    return utc.toLocal();
  }

  /// Operación inversa a fromJson, con las mismas claves de la API.
  /// Se usa para guardar favoritos en shared_preferences.
  Map<String, dynamic> toJson() => {
    'article_id': id,
    'title': titulo,
    'description': descripcion,
    'link': enlace,
    'image_url': imagenUrl,
    'source_name': fuente,
    'source_icon': fuenteIcono,
    'pubDate': fecha?.toUtc().toIso8601String(),
    'category': categorias,
  };
}
