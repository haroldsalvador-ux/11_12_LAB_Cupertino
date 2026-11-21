import 'package:flutter/cupertino.dart';

import '../main.dart';
import '../theme.dart';
import 'lista_alumnos_screen.dart';
import 'login_screen.dart';
import 'perfil_screen.dart';
import 'registro_alumno_screen.dart';

/// Panel principal que se muestra después del inicio de sesión.
///
/// Es [StatefulWidget] porque el resumen (total, aprobados, promedio) debe
/// recalcularse cada vez que el usuario vuelve de registrar o eliminar alumnos.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.correo});

  /// Correo con el que se inició sesión (llega como argumento desde el login).
  final String correo;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Abre otra pantalla con transición de iOS y espera a que el usuario vuelva.
  /// `await` hace que el setState se ejecute recién al regresar, con lo que el
  /// resumen se actualiza sin necesidad de un gestor de estado externo.
  Future<void> _abrir(Widget pantalla) async {
    await Navigator.push(context, CupertinoPageRoute(builder: (_) => pantalla));
    setState(() {});
  }

  /// Alerta Cupertino para confirmar el cierre de sesión.
  void _confirmarCierre() {
    // showCupertinoDialog muestra el diálogo centrado con el fondo oscurecido.
    // Se usa `ctx` (contexto del diálogo) para cerrarlo y `context` (contexto de
    // la pantalla) para navegar, porque son dos rutas distintas en el Navigator.
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('¿Salir de la cuenta?'),
        content: const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text('Tendrás que ingresar tu correo y contraseña otra vez.'),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Quedarme'),
          ),
          // isDestructiveAction pinta la acción en rojo (convención de iOS).
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              // pushAndRemoveUntil con (_) => false borra todo el historial:
              // después de salir, el botón "atrás" no puede volver al panel.
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Panel'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _confirmarCierre,
          child: const Icon(CupertinoIcons.square_arrow_right),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Hola, Harold',
                style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.texto)),
            const SizedBox(height: 4),
            Text(widget.correo,
                style: const TextStyle(fontSize: 14, color: AppColors.textoSuave)),
            const SizedBox(height: 20),
            _resumen(),
            const TituloSeccion('Opciones'),
            // Menú de opciones como lista agrupada de ListTiles Cupertino.
            CupertinoListSection.insetGrouped(
              margin: EdgeInsets.zero,
              children: [
                _opcion(CupertinoIcons.person_add_solid, AppColors.primario,
                    'Registrar alumno', 'Agrega un estudiante y su nota',
                    () => _abrir(const RegistroAlumnoScreen())),
                _opcion(CupertinoIcons.list_bullet, AppColors.acento,
                    'Listar alumnos', 'Busca, filtra y elimina registros',
                    () => _abrir(const ListaAlumnosScreen())),
                _opcion(CupertinoIcons.person_crop_circle_fill, CupertinoColors.systemIndigo,
                    'Mi perfil', 'Tus datos como estudiante',
                    () => _abrir(PerfilScreen(correo: widget.correo))),
              ],
            ),
            const SizedBox(height: 16),
            CupertinoListSection.insetGrouped(
              margin: EdgeInsets.zero,
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.power, color: AppColors.desaprobado),
                  title: const Text('Cerrar sesión',
                      style: TextStyle(color: AppColors.desaprobado)),
                  onTap: _confirmarCierre,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Tarjeta con degradado que resume la sección. Los valores se leen del
  /// repositorio global en cada build, por eso siempre están al día.
  Widget _resumen() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primario, AppColors.primarioOscuro],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Resumen de la sección',
              style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 14)),
          const SizedBox(height: 14),
          Row(
            children: [
              _dato('${repositorio.total}', 'Alumnos'),
              _dato('${repositorio.aprobados}', 'Aprobados'),
              _dato('${repositorio.desaprobados}', 'Desaprob.'),
              _dato(repositorio.promedio.toStringAsFixed(1), 'Promedio'),
            ],
          ),
        ],
      ),
    );
  }

  /// Un número grande con su etiqueta. Expanded reparte el ancho en partes iguales.
  Widget _dato(String valor, String etiqueta) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(valor,
              style: const TextStyle(
                  color: CupertinoColors.white, fontSize: 26, fontWeight: FontWeight.w700)),
          Text(etiqueta, style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 12)),
        ],
      ),
    );
  }

  /// Fabrica una opción del menú. `.notched` es la variante de iOS con el icono
  /// dentro de un cuadrado de color y el separador alineado al texto.
  /// El callback [onTap] se pasa como argumento para reutilizar el mismo widget.
  CupertinoListTile _opcion(
      IconData icono, Color color, String titulo, String sub, VoidCallback onTap) {
    return CupertinoListTile.notched(
      leading: Container(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(7)),
        child: Icon(icono, color: CupertinoColors.white, size: 18),
      ),
      title: Text(titulo),
      subtitle: Text(sub),
      trailing: const CupertinoListTileChevron(),
      onTap: onTap,
    );
  }
}
