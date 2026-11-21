import 'package:flutter/cupertino.dart';

import '../main.dart';
import '../models/alumno.dart';
import '../theme.dart';

/// Formulario para registrar un alumno nuevo con su nota final.
class RegistroAlumnoScreen extends StatefulWidget {
  const RegistroAlumnoScreen({super.key});

  @override
  State<RegistroAlumnoScreen> createState() => _RegistroAlumnoScreenState();
}

class _RegistroAlumnoScreenState extends State<RegistroAlumnoScreen> {
  // Un controlador por campo para leer lo que escribió el usuario.
  final _nombresCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _notaCtrl = TextEditingController();

  // Mensajes de validación que se muestran debajo del formulario.
  final List<String> _errores = [];

  /// Los controladores reservan recursos; se liberan al cerrar la pantalla
  /// para evitar fugas de memoria.
  @override
  void dispose() {
    _nombresCtrl.dispose();
    _apellidosCtrl.dispose();
    _notaCtrl.dispose();
    super.dispose();
  }

  /// Valida los datos y, si son correctos, guarda el alumno.
  void _guardar() {
    // trim() quita espacios para que "   " no cuente como nombre válido.
    final nombres = _nombresCtrl.text.trim();
    final apellidos = _apellidosCtrl.text.trim();
    // tryParse devuelve null si el texto no es un entero (ej. "abc" o "15.5"),
    // en vez de lanzar una excepción como int.parse.
    final nota = int.tryParse(_notaCtrl.text.trim());

    // "Collection if": cada mensaje se agrega a la lista solo si su condición
    // se cumple. Así se muestran todos los errores a la vez, no uno por uno.
    final errores = <String>[
      if (nombres.isEmpty) 'Ingresa los nombres.',
      if (apellidos.isEmpty) 'Ingresa los apellidos.',
      if (nota == null || nota < 0 || nota > 20) 'La nota debe ser un número entero de 0 a 20.',
    ];
    setState(() => _errores
      ..clear()
      ..addAll(errores));
    if (errores.isNotEmpty) return;

    // Aquí `nota` ya no puede ser null (lo descartó la validación), por eso el `!`.
    final alumno = Alumno(nombres: nombres, apellidos: apellidos, nota: nota!);
    repositorio.agregar(alumno);

    // Alerta de éxito. Al pulsar "Listo" se cierran dos rutas: primero el
    // diálogo (ctx) y luego el formulario (context), volviendo a la pantalla anterior.
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Alumno registrado'),
        content: Text('${alumno.nombreCompleto} quedó '
            '${alumno.aprobado ? 'aprobado' : 'desaprobado'} con ${alumno.nota}.'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Listo'),
          ),
        ],
      ),
    );
  }

  /// Fila del formulario: etiqueta a la izquierda y campo sin borde a la derecha,
  /// como en los formularios de Ajustes de iOS. [teclado] es un argumento
  /// opcional con nombre para pedir el teclado numérico solo en la nota.
  Widget _campo(String etiqueta, TextEditingController ctrl, String placeholder,
      {TextInputType? teclado}) {
    return CupertinoFormRow(
      prefix: SizedBox(width: 90, child: Text(etiqueta)),
      child: CupertinoTextField.borderless(
        controller: ctrl,
        placeholder: placeholder,
        keyboardType: teclado,
        textAlign: TextAlign.right,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Nuevo alumno'),
        previousPageTitle: 'Atrás',
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Completa los datos del estudiante. La nota mínima aprobatoria '
                'es $notaAprobatoria.',
                style: TextStyle(color: AppColors.textoSuave, fontSize: 15),
              ),
            ),
            CupertinoFormSection.insetGrouped(
              backgroundColor: AppColors.fondo,
              header: const Text('DATOS PERSONALES'),
              children: [
                _campo('Nombres', _nombresCtrl, 'Ej. Valeria'),
                _campo('Apellidos', _apellidosCtrl, 'Ej. Quispe'),
              ],
            ),
            CupertinoFormSection.insetGrouped(
              backgroundColor: AppColors.fondo,
              header: const Text('EVALUACIÓN'),
              footer: const Text('Escala vigesimal (0 – 20)'),
              children: [
                _campo('Nota final', _notaCtrl, '0 – 20', teclado: TextInputType.number),
              ],
            ),
            // El bloque de errores solo existe en el árbol si hay errores.
            if (_errores.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _errores
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(children: [
                              const Icon(CupertinoIcons.exclamationmark_circle_fill,
                                  color: AppColors.desaprobado, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(e,
                                    style: const TextStyle(
                                        color: AppColors.desaprobado, fontSize: 13)),
                              ),
                            ]),
                          ))
                      .toList(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CupertinoButton.filled(
                onPressed: _guardar,
                child: const Text('Guardar registro'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
