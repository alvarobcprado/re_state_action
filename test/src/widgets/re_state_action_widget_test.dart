import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_state_action/src/widgets/re_state_action_widget.dart';

import '../../helpers.dart';

void main() {
  late TestStateAction reState;
  var actionText = 'Test';

  void onAction(String action) {
    actionText = '$actionText $action';
  }

  setUp(() {
    reState = TestStateAction(0);
    actionText = 'Test';
  });

  group(
    'Builder',
    () {
      testWidgets(
        'rebuilds when state changes',
        (tester) async {
          final widget = MaterialApp(
            home: ReStateActionWidget<int, String>(
              reState: reState,
              onAction: onAction,
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
          expect(actionText, 'Test');
        },
      );

      testWidgets(
        'not rebuild if buildWhen condition is false',
        (widgetTester) async {
          final widget = MaterialApp(
            home: ReStateActionWidget<int, String>(
              reState: reState,
              onAction: onAction,
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

      testWidgets(
        'not rebuild if buildWhen condition is false and action is emitted',
        (widgetTester) async {
          final widget = MaterialApp(
            home: ReStateActionWidget<int, String>(
              reState: reState,
              onAction: onAction,
              buildWhen: (previous, current) => current > 1,
              builder: (context, state, child) => Text('$state'),
            ),
          );

          await widgetTester.pumpWidget(widget);
          await widgetTester.pumpAndSettle();
          reState.dispatchAction();
          await widgetTester.pumpAndSettle();
          expect(find.text('0'), findsOneWidget);
          expect(find.text('1'), findsNothing);
          reState.increment();
          await widgetTester.pumpAndSettle();
          expect(find.text('1'), findsNothing);
          expect(find.text('0'), findsOneWidget);
          reState.dispatchAction();
          await widgetTester.pumpAndSettle();
          expect(find.text('0'), findsOneWidget);
          expect(find.text('1'), findsNothing);
          reState.increment();
          await widgetTester.pumpAndSettle();
          expect(find.text('0'), findsNothing);
          expect(find.text('1'), findsNothing);
          expect(find.text('2'), findsOneWidget);
        },
      );
    },
  );

  group(
    'Action Listener',
    () {
      testWidgets(
        'call onAction when action is emitted',
        (tester) async {
          final widget = MaterialApp(
            home: ReStateActionWidget<int, String>(
              reState: reState,
              onAction: onAction,
              builder: (context, state, child) => Text('$state'),
            ),
          );

          await tester.pumpWidget(widget);
          await tester.pumpAndSettle();
          reState.dispatchAction();
          await tester.pumpAndSettle();
          expect(actionText, 'Test action');
          expect(find.text('0'), findsOneWidget);
        },
      );

      testWidgets(
        'not call onAction if listenWhen condition is false',
        (widgetTester) async {
          final widget = MaterialApp(
            home: ReStateActionWidget<int, String>(
              reState: reState,
              onAction: onAction,
              listenWhen: (previous, current) => previous != null,
              builder: (context, state, child) => Text('$state'),
            ),
          );

          await widgetTester.pumpWidget(widget);
          await widgetTester.pumpAndSettle();
          reState.dispatchAction();
          await widgetTester.pumpAndSettle();
          expect(actionText, 'Test');
          expect(find.text('0'), findsOneWidget);
          reState.dispatchAction();
          await widgetTester.pumpAndSettle();
          expect(actionText, 'Test action');
          expect(find.text('0'), findsOneWidget);
        },
      );
    },
  );
}
