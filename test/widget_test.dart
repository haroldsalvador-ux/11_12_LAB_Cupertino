import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cupertino_alumnos/main.dart';

void main() {
  testWidgets('Login muestra alerta con datos inválidos', (tester) async {
    await tester.pumpWidget(const NotasApp());
    expect(find.text('Registro de Notas'), findsOneWidget);
    await tester.tap(find.widgetWithText(CupertinoButton, 'Iniciar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('No pudimos iniciar sesión'), findsOneWidget);
  });
}
