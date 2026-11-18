import 'package:flutter/cupertino.dart';

/// Paleta de la app: azul petróleo con acento coral.
class AppColors {
  static const primario = Color(0xFF0E7490);
  static const primarioOscuro = Color(0xFF155E75);
  static const acento = Color(0xFFF97316);
  static const fondo = Color(0xFFF2F6F8);
  static const tarjeta = CupertinoColors.white;
  static const texto = Color(0xFF0F172A);
  static const textoSuave = Color(0xFF64748B);
  static const aprobado = Color(0xFF16A34A);
  static const desaprobado = Color(0xFFDC2626);
}

/// Contenedor blanco con bordes redondeados usado en toda la app.
class Tarjeta extends StatelessWidget {
  const Tarjeta({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tarjeta,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

/// Etiqueta de sección en mayúsculas, estilo ajustes de iOS.
class TituloSeccion extends StatelessWidget {
  const TituloSeccion(this.texto, {super.key});
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Text(
        texto.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textoSuave,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
