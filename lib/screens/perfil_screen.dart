import 'package:flutter/cupertino.dart';

import '../theme.dart';
import 'lista_alumnos_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key, required this.correo});
  final String correo;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Mi perfil'),
        previousPageTitle: 'Panel',
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 28),
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
            CupertinoListSection.insetGrouped(
              backgroundColor: AppColors.fondo,
              header: const Text('INFORMACIÓN PERSONAL',
                  style: TextStyle(fontSize: 13, color: AppColors.textoSuave)),
              children: [
                _fila(CupertinoIcons.person, 'Nombre', 'Harold Salvador Zarate'),
                _fila(CupertinoIcons.mail, 'Correo', correo),
                _fila(CupertinoIcons.building_2_fill, 'Institución', 'Tecsup'),
                _fila(CupertinoIcons.book, 'Curso', 'Apps Móviles Multiplataforma'),
                _fila(CupertinoIcons.calendar, 'Periodo', '2026-II'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  CupertinoListTile _fila(IconData icono, String titulo, String valor) {
    return CupertinoListTile(
      leading: Icon(icono, color: AppColors.primario),
      title: Text(valor),
      subtitle: Text(titulo),
    );
  }
}
