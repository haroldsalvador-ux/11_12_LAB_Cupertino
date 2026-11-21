import 'package:flutter/cupertino.dart';

import '../theme.dart';
import 'lista_alumnos_screen.dart';

/// Pantalla "Mi perfil": muestra los datos del estudiante que inició sesión.
///
/// Es un [StatelessWidget] porque no cambia mientras está visible; solo recibe
/// el [correo] desde el panel principal a través del constructor (argumento
/// entre pantallas).
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key, required this.correo});
  final String correo;

  @override
  Widget build(BuildContext context) {
    // Lista de mapas: cada Map describe una fila del perfil (icono, etiqueta y
    // valor). Así se agregan o quitan filas sin repetir widgets.
    final List<Map<String, dynamic>> datos = [
      {'icono': CupertinoIcons.person, 'titulo': 'Nombre', 'valor': 'Harold Salvador Zarate'},
      {'icono': CupertinoIcons.mail, 'titulo': 'Correo', 'valor': correo},
      {'icono': CupertinoIcons.building_2_fill, 'titulo': 'Institución', 'valor': 'Tecsup'},
      {'icono': CupertinoIcons.book, 'titulo': 'Curso', 'valor': 'Apps Móviles Multiplataforma'},
      {'icono': CupertinoIcons.calendar, 'titulo': 'Periodo', 'valor': '2026-II'},
    ];

    return CupertinoPageScaffold(
      // previousPageTitle muestra "< Panel" como en iOS en lugar de "< Atrás".
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Mi perfil'),
        previousPageTitle: 'Panel',
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 28),
            // Avatar circular reutilizado de la pantalla de listado.
            const Center(child: CircleAvatarCupertino(texto: 'HS', size: 96)),
            const SizedBox(height: 14),
            const Text('Harold Salvador Zarate',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.texto)),
            const SizedBox(height: 4),
            const Text('Diseño y Desarrollo de Software',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textoSuave)),
            // insetGrouped = lista agrupada con bordes redondeados (estilo Ajustes de iOS).
            CupertinoListSection.insetGrouped(
              backgroundColor: AppColors.fondo,
              header: const Text('INFORMACIÓN PERSONAL',
                  style: TextStyle(fontSize: 13, color: AppColors.textoSuave)),
              // .map() convierte cada Map en un CupertinoListTile.
              children: datos
                  .map((d) => _fila(d['icono'] as IconData, d['titulo'] as String,
                      d['valor'] as String))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Fila del perfil: el valor va como título y la etiqueta como subtítulo,
  /// así los textos largos (como el correo) no se cortan.
  CupertinoListTile _fila(IconData icono, String titulo, String valor) {
    return CupertinoListTile(
      leading: Icon(icono, color: AppColors.primario),
      title: Text(valor),
      subtitle: Text(titulo),
    );
  }
}
