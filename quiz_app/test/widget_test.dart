// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/main.dart';

void main() {
  testWidgets('Quiz App Setup Screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QuizApp());

    // Verify that the setup screen renders its main title
    expect(find.text('Inicializar Sessão'), findsOneWidget);
    expect(find.text('E-MAIL DO JOGADOR'), findsOneWidget);
    expect(find.text('INICIAR QUIZ'), findsOneWidget);
  });
}
