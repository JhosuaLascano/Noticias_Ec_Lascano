import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Franja amarillo-azul-rojo (proporción 2:1:1 de la bandera).
class FranjaBandera extends StatelessWidget implements PreferredSizeWidget {
  const FranjaBandera({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(4);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 2, child: ColoredBox(color: ColoresEC.amarillo)),
          Expanded(child: ColoredBox(color: ColoresEC.azul)),
          Expanded(child: ColoredBox(color: ColoresEC.rojo)),
        ],
      ),
    );
  }
}

/// Lista "esqueleto" que se muestra mientras llegan los datos.
class ListaEsqueleto extends StatefulWidget {
  const ListaEsqueleto({super.key});

  @override
  State<ListaEsqueleto> createState() => _ListaEsqueletoState();
}

class _ListaEsqueletoState extends State<ListaEsqueleto>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animacion = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _animacion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHigh;
    Widget caja({double? w, double? h, double r = 8}) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(r),
      ),
    );

    return FadeTransition(
      opacity: Tween(begin: 0.45, end: 1.0).animate(_animacion),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        children: [
          AspectRatio(aspectRatio: 16 / 10, child: caja(r: 18)),
          for (var i = 0; i < 4; i++)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  caja(w: 96, h: 96, r: 12),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        caja(w: 70, h: 12),
                        const SizedBox(height: 10),
                        caja(h: 14),
                        const SizedBox(height: 6),
                        caja(w: 160, h: 14),
                        const SizedBox(height: 12),
                        caja(w: 110, h: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Mensaje centrado con ícono (error, sin resultados, lista vacía).
class MensajeEstado extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String? detalle;
  final String? textoBoton;
  final VoidCallback? onBoton;

  const MensajeEstado({
    super.key,
    required this.icono,
    required this.titulo,
    this.detalle,
    this.textoBoton,
    this.onBoton,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: tema.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icono,
                size: 40,
                color: tema.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: tema.textTheme.titleMedium,
            ),
            if (detalle != null) ...[
              const SizedBox(height: 8),
              Text(
                detalle!,
                textAlign: TextAlign.center,
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (onBoton != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onBoton,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(textoBoton ?? 'Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
