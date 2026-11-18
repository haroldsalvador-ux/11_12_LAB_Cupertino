/// Nota mínima para aprobar en el sistema vigesimal.
const int notaAprobatoria = 13;

class Alumno {
  Alumno({required this.nombres, required this.apellidos, required this.nota});

  final String nombres;
  final String apellidos;
  final int nota;

  String get nombreCompleto => '$nombres $apellidos';
  bool get aprobado => nota >= notaAprobatoria;
  String get iniciales =>
      '${nombres.isNotEmpty ? nombres[0] : ''}${apellidos.isNotEmpty ? apellidos[0] : ''}'
          .toUpperCase();
}

/// Lista de alumnos en memoria con datos iniciales de ejemplo.
class AlumnoRepositorio {
  final List<Alumno> _alumnos = [
    Alumno(nombres: 'Valeria', apellidos: 'Quispe', nota: 17),
    Alumno(nombres: 'Diego', apellidos: 'Mendoza', nota: 11),
    Alumno(nombres: 'Camila', apellidos: 'Rojas', nota: 19),
    Alumno(nombres: 'Joaquín', apellidos: 'Huamán', nota: 8),
    Alumno(nombres: 'Lucía', apellidos: 'Paredes', nota: 14),
  ];

  List<Alumno> get todos => List.unmodifiable(_alumnos);
  int get total => _alumnos.length;
  int get aprobados => _alumnos.where((a) => a.aprobado).length;
  int get desaprobados => total - aprobados;

  double get promedio => _alumnos.isEmpty
      ? 0
      : _alumnos.map((a) => a.nota).reduce((a, b) => a + b) / _alumnos.length;

  void agregar(Alumno alumno) => _alumnos.add(alumno);
  void eliminar(Alumno alumno) => _alumnos.remove(alumno);
}
