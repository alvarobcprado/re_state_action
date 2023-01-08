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
  });

  testWidgets(
    'Rebuilds when state changes',
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
    'Calls onAction when action is emitted',
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
}
