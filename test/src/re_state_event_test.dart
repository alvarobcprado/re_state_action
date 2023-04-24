import 'package:flutter_test/flutter_test.dart';
import 'package:re_state_action/src/utils/exceptions.dart';

import '../helpers.dart';

void main() {
  group(
    'ReStateEvent',
    () {
      test(
        'initialize with initial state',
        () {
          final reState = TestStateEvent(0);
          expect(reState.state, 0);
        },
      );

      test(
        'throws a ReDuplicateEventHandlerException',
        () {
          expect(
            () => WrongTestStateEvent(0),
            throwsA(isA<ReDuplicateEventHandlerException>()),
          );

          try {
            WrongTestStateEvent(0);
          } on ReDuplicateEventHandlerException catch (e) {
            expect(
              e.toString(),
              ReDuplicateEventHandlerException(IncrementEvent).toString(),
            );
          }
        },
      );

      test(
        'emit new state updates current state',
        () async {
          final reState = TestStateEvent(0)..process(IncrementEvent());

          await expectLater(reState.stateStream, emitsInOrder([0, 1]));
        },
      );

      test(
        'listen to state updates',
        () async {
          final reState = TestStateEvent(0);
          var lastState = 0;
          var lastState2 = 0;

          reState
            ..listenState((state) {
              lastState = state;
            })
            ..listenState((state) {
              lastState2 = state * 2;
            })
            ..process(IncrementEvent());

          await expectLater(reState.stateStream, emitsInOrder([0, 1]));
          expect(lastState, 1);
          expect(lastState2, 2);
        },
      );

      test(
        'remove listener from state updates',
        () async {
          final reState = TestStateEvent(0);
          var lastState = 0;
          var lastState2 = 0;

          void listenerToRemove(int state) {
            lastState2 = state * 2;
          }

          reState
            ..listenState((state) {
              lastState = state;
            })
            ..listenState(listenerToRemove)
            ..removeStateListener(listenerToRemove)
            ..process(IncrementEvent());

          await expectLater(reState.stateStream, emitsInOrder([0, 1]));
          expect(lastState, 1);
          expect(lastState2, 0);
        },
      );

      test(
        'dispose closes state stream',
        () async {
          final reState = TestStateEvent(0)..dispose();
          await expectLater(reState.stateStream, emitsInOrder([0, emitsDone]));
        },
      );
    },
  );
}
