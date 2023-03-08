import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_state_action/src/widgets/re_state_widget.dart';

import '../../helpers.dart';

void main() {
  late TestState reState;

  setUp(() {
    reState = TestState(0);
  });

  testWidgets(
    'rebuild widget when state changes',
    (tester) async {
      final widget = MaterialApp(
        home: ReStateWidget<int>(
          reState: reState,
          builder: (context, state, child) => Text('$state'),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);
      reState.increment();
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    },
  );

  testWidgets(
    'not rebuild if buildWhen condition is false',
    (widgetTester) async {
      final widget = MaterialApp(
        home: ReStateWidget<int>(
          reState: reState,
          buildWhen: (previous, current) => current > 1,
          builder: (context, state, child) => Text('$state'),
        ),
      );

      await widgetTester.pumpWidget(widget);
      await widgetTester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);
      reState.increment();
      await widgetTester.pumpAndSettle();
      expect(find.text('1'), findsNothing);
      expect(find.text('0'), findsOneWidget);
      reState.increment();
      await widgetTester.pumpAndSettle();
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsNothing);
      expect(find.text('2'), findsOneWidget);
    },
  );
}
