import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_api/main.dart'; // Reemplaza 'flutter_api' con el nombre de tu proyecto.

void main() {
  testWidgets('Verifica que MyApp se ejecute correctamente', (WidgetTester tester) async {
    // Construye la app.
    await tester.pumpWidget(MyApp());

    // Verifica que la app muestra la interfaz inicial.
    expect(find.text('Buscar Pokémon'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
