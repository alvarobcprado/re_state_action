import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_state_action/re_state_action.dart';

import '../../helpers.dart';

void main() {
  late TestStateAction reState;
  var lastAction = 'Test';

  void onAction(String action) {
    lastAction = '$lastAction $action';
  }

  setUp(() {
    reState = TestStateAction(0);
    lastAction = 'Test';
  });

  testWidgets(
    'call onAction when action is emitted',
    (tester) async {
      final widget = MaterialApp(
        home: ReActionListener<String>(
          reState: reState,
          onAction: onAction,
          child: const Text('Test'),
        ),
      );

      await tester.pumpWidget(widget);
      reState.dispatchAction();
      await tester.pumpAndSettle();
      expect(lastAction, 'Test action');
    },
  );

  testWidgets(
    'not call onAction when action is emitted and listenWhen condition is'
    ' false',
    (tester) async {
      final widget = MaterialApp(
        home: ReActionListener<String>(
          reState: reState,
          onAction: onAction,
          listenWhen: (lastAction, action) => lastAction != null,
          child: const Text('Test'),
        ),
      );

      await tester.pumpWidget(widget);
      reState.dispatchAction();
      await tester.pumpAndSettle();
      expect(lastAction, 'Test');
      reState.dispatchAction();
      await tester.pumpAndSettle();
      expect(lastAction, 'Test action');
    },
  );
}
