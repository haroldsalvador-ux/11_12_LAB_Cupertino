// Laboratorio 11 y 12 - Gestión de alumnos con widgets Cupertino
// Autor: Harold Salvador Zarate - Tecsup 2026-II

import 'package:flutter/cupertino.dart';

import 'models/alumno.dart';
import 'screens/login_screen.dart';
import 'theme.dart';

void main() {
  runApp(const NotasApp());
}

class NotasApp extends StatelessWidget {
  const NotasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Registro de Notas',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primario,
        scaffoldBackgroundColor: AppColors.fondo,
      ),
      home: LoginScreen(),
    );
  }
}

/// Repositorio en memoria compartido por todas las pantallas.
final AlumnoRepositorio repositorio = AlumnoRepositorio();
