import 'package:intl/intl.dart';

/// "Hace 5 min", "Hace 3 h", "Hace 2 d" o la fecha completa si es antigua.
String haceCuanto(DateTime? fecha, {DateTime? ahora}) {
  if (fecha == null) return '';
  final diferencia = (ahora ?? DateTime.now()).difference(fecha);
  if (diferencia.inMinutes < 1) return 'Ahora';
  if (diferencia.inMinutes < 60) return 'Hace ${diferencia.inMinutes} min';
  if (diferencia.inHours < 24) return 'Hace ${diferencia.inHours} h';
  if (diferencia.inDays < 7) return 'Hace ${diferencia.inDays} d';
  return DateFormat('dd/MM/yyyy').format(fecha);
}

/// Fecha completa para la pantalla de detalle.
String fechaCompleta(DateTime? fecha) =>
    fecha == null ? '' : DateFormat('dd/MM/yyyy · HH:mm').format(fecha);
