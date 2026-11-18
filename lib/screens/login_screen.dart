import 'package:flutter/cupertino.dart';

import '../theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correoCtrl = TextEditingController();
  final _claveCtrl = TextEditingController();
  bool _ocultarClave = true;

  @override
  void dispose() {
    _correoCtrl.dispose();
    _claveCtrl.dispose();
    super.dispose();
  }

  bool _correoValido(String correo) =>
      RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$').hasMatch(correo);

  void _ingresar() {
    final correo = _correoCtrl.text.trim();
    final clave = _claveCtrl.text;

    if (!_correoValido(correo) || clave.length < 6) {
      // Alerta Cupertino de validación
      showCupertinoDialog<void>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('No pudimos iniciar sesión'),
          content: const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              'Verifica que el correo tenga un formato válido y que la '
              'contraseña tenga 6 caracteres o más.',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Volver a intentar'),
            ),
          ],
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (_) => HomeScreen(correo: correo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          children: [
            Center(
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primario, AppColors.primarioOscuro],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(CupertinoIcons.book_fill,
                    color: CupertinoColors.white, size: 42),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Registro de Notas',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.texto),
            ),
            const SizedBox(height: 6),
            const Text(
              'Controla el rendimiento de tu sección',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: AppColors.textoSuave),
            ),
            const SizedBox(height: 36),
            Tarjeta(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Correo institucional',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: _correoCtrl,
                    placeholder: 'usuario@tecsup.edu.pe',
                    keyboardType: TextInputType.emailAddress,
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(CupertinoIcons.mail, color: AppColors.textoSuave),
                    ),
                    padding: const EdgeInsets.all(12),
                  ),
                  const SizedBox(height: 16),
                  const Text('Contraseña',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: _claveCtrl,
                    placeholder: 'Al menos 6 caracteres',
                    obscureText: _ocultarClave,
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(CupertinoIcons.lock, color: AppColors.textoSuave),
                    ),
                    suffix: CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      minimumSize: Size.zero,
                      onPressed: () => setState(() => _ocultarClave = !_ocultarClave),
                      child: Icon(
                        _ocultarClave ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                        size: 20,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    onSubmitted: (_) => _ingresar(),
                  ),
                  const SizedBox(height: 24),
                  CupertinoButton.filled(
                    onPressed: _ingresar,
                    child: const Text('Iniciar sesión'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tecsup · Aplicaciones Móviles Multiplataforma',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textoSuave),
            ),
          ],
        ),
      ),
    );
  }
}
