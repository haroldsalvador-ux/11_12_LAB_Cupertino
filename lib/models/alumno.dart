/// Nota mínima para aprobar en el sistema vigesimal (0 a 20).
/// Es una constante global para que el modelo, el listado y el formulario
/// usen el mismo valor; si cambia la regla, se modifica en un solo lugar.
const int notaAprobatoria = 13;

/// Modelo de datos de un alumno.
///
/// Los campos son `final` (inmutables): un alumno no cambia después de crearse.
/// Los datos derivados (nombre completo, estado, iniciales) son getters, así
/// nunca quedan desactualizados respecto a los campos originales.
class Alumno {
  Alumno({required this.nombres, required this.apellidos, required this.nota});

  final String nombres;
  final String apellidos;
  final int nota;

  String get nombreCompleto => '$nombres $apellidos';

  /// true si la nota alcanza la mínima aprobatoria.
  bool get aprobado => nota >= notaAprobatoria;

  /// Primera letra del nombre y del apellido (ej. "Valeria Quispe" -> "VQ").
  /// Se valida que no estén vacíos para no fallar con índices fuera de rango.
  String get iniciales =>
      '${nombres.isNotEmpty ? nombres[0] : ''}${apellidos.isNotEmpty ? apellidos[0] : ''}'
          .toUpperCase();
}

/// Repositorio en memoria: guarda la lista de alumnos y calcula estadísticas.
///
/// Separar los datos de las pantallas permite que el panel y el listado lean
/// la misma información. Los datos se pierden al cerrar la app (no hay base
/// de datos en este laboratorio).
class AlumnoRepositorio {
  // Lista privada (el "_" la hace privada al archivo) con datos de ejemplo.
  final List<Alumno> _alumnos = [
    Alumno(nombres: 'Valeria', apellidos: 'Quispe', nota: 17),
    Alumno(nombres: 'Diego', apellidos: 'Mendoza', nota: 11),
    Alumno(nombres: 'Camila', apellidos: 'Rojas', nota: 19),
    Alumno(nombres: 'Joaquín', apellidos: 'Huamán', nota: 8),
    Alumno(nombres: 'Lucía', apellidos: 'Paredes', nota: 14),
  ];

  /// Copia de solo lectura: las pantallas pueden recorrerla pero no
  /// modificarla directamente; para cambiarla deben usar agregar/eliminar.
  List<Alumno> get todos => List.unmodifiable(_alumnos);

  int get total => _alumnos.length;

  /// where() filtra la lista y length cuenta cuántos cumplen la condición.
  int get aprobados => _alumnos.where((a) => a.aprobado).length;
  int get desaprobados => total - aprobados;

  /// Promedio de notas: map() extrae las notas, reduce() las suma y se divide
  /// entre la cantidad. Se controla la lista vacía para no dividir entre cero.
  double get promedio => _alumnos.isEmpty
      ? 0
      : _alumnos.map((a) => a.nota).reduce((a, b) => a + b) / _alumnos.length;

  /// Cantidad de alumnos por estado, como `Map<String, int>`.
  /// Ejemplo: {'Aprobados': 3, 'Desaprobados': 2}.
  Map<String, int> get conteoPorEstado => {
        'Aprobados': aprobados,
        'Desaprobados': desaprobados,
      };

  void agregar(Alumno alumno) => _alumnos.add(alumno);
  void eliminar(Alumno alumno) => _alumnos.remove(alumno);
}
