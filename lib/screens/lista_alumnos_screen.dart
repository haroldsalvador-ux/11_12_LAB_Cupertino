import 'package:flutter/cupertino.dart';

import '../main.dart';
import '../models/alumno.dart';
import '../theme.dart';
import 'registro_alumno_screen.dart';

enum Filtro { todos, aprobados, desaprobados }

class ListaAlumnosScreen extends StatefulWidget {
  const ListaAlumnosScreen({super.key});

  @override
  State<ListaAlumnosScreen> createState() => _ListaAlumnosScreenState();
}

class _ListaAlumnosScreenState extends State<ListaAlumnosScreen> {
  Filtro _filtro = Filtro.todos;
  String _busqueda = '';

  List<Alumno> get _visibles {
    final texto = _busqueda.toLowerCase();
    return repositorio.todos.where((a) {
      final coincide = a.nombreCompleto.toLowerCase().contains(texto);
      switch (_filtro) {
        case Filtro.aprobados:
          return coincide && a.aprobado;
        case Filtro.desaprobados:
          return coincide && !a.aprobado;
        case Filtro.todos:
          return coincide;
      }
    }).toList();
  }

  Future<void> _nuevo() async {
    await Navigator.push(
        context, CupertinoPageRoute(builder: (_) => const RegistroAlumnoScreen()));
    setState(() {});
  }

  void _opciones(Alumno alumno) {
    // Hoja de acciones Cupertino para cada alumno
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(alumno.nombreCompleto),
        message: Text('Nota final: ${alumno.nota} / 20'),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              _confirmarEliminar(alumno);
            },
            child: const Text('Eliminar alumno'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
      ),
    );
  }

  void _confirmarEliminar(Alumno alumno) {
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Eliminar registro'),
        content: Text('¿Seguro que deseas eliminar a ${alumno.nombreCompleto}?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              setState(() => repositorio.eliminar(alumno));
              Navigator.pop(ctx);
            },
            child: const Text('Sí, eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = _visibles;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Alumnos'),
        previousPageTitle: 'Panel',
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _nuevo,
          child: const Icon(CupertinoIcons.add_circled_solid),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: CupertinoSearchTextField(
                placeholder: 'Buscar alumno',
                onChanged: (v) => setState(() => _busqueda = v),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<Filtro>(
                  groupValue: _filtro,
                  onValueChanged: (v) => setState(() => _filtro = v ?? Filtro.todos),
                  children: const {
                    Filtro.todos: Text('Todos'),
                    Filtro.aprobados: Text('Aprobados'),
                    Filtro.desaprobados: Text('Desaprobados'),
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text('${lista.length} registro(s)',
                      style: const TextStyle(color: AppColors.textoSuave, fontSize: 13)),
                  const Spacer(),
                  const Text('Aprueba con $notaAprobatoria',
                      style: TextStyle(color: AppColors.textoSuave, fontSize: 13)),
                ],
              ),
            ),
            Expanded(
              child: lista.isEmpty
                  ? const Center(
                      child: Text('No hay alumnos para mostrar',
                          style: TextStyle(color: AppColors.textoSuave)),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: lista.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _fila(lista[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fila(Alumno a) {
    final color = a.aprobado ? AppColors.aprobado : AppColors.desaprobado;
    return GestureDetector(
      onLongPress: () => _opciones(a),
      child: Tarjeta(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            CircleAvatarCupertino(texto: a.iniciales),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.nombreCompleto,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(a.aprobado ? 'Aprobado' : 'Desaprobado',
                      style: TextStyle(fontSize: 13, color: color)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(a.nota.toString().padLeft(2, '0'),
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w700, fontSize: 18)),
            ),
            CupertinoButton(
              padding: const EdgeInsets.only(left: 6),
              minimumSize: Size.zero,
              onPressed: () => _opciones(a),
              child: const Icon(CupertinoIcons.ellipsis_vertical, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleAvatarCupertino extends StatelessWidget {
  const CircleAvatarCupertino({super.key, required this.texto, this.size = 44});
  final String texto;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0x1A0E7490),
        shape: BoxShape.circle,
      ),
      child: Text(texto,
          style: TextStyle(
              color: AppColors.primario,
              fontWeight: FontWeight.w700,
              fontSize: size * 0.36)),
    );
  }
}
