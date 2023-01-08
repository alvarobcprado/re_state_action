import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  test(
    'initialize with initial state',
    () {
      final reState = TestState(0);
      expect(reState.state, 0);
    },
  );

  test(
    'emit new state updates current state',
    () {
      final reState = TestState(0)..increment();
      expect(reState.state, 1);
    },
  );

  test(
    'listen to state updates',
    () async {
      final reState = TestState(0);
      var lastState = 0;
      var lastState2 = 0;

      reState
        ..listenState((state) {
          lastState = state;
        })
        ..listenState((state) {
          lastState2 = state * 2;
        })
        ..increment();

      await expectLater(reState.stateStream, emits(1));
      expect(lastState, 1);
      expect(lastState2, 2);
    },
  );

  test(
    'remove listener from state updates',
    () async {
      final reState = TestState(0);
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
        ..increment();

      await expectLater(reState.stateStream, emits(1));
      expect(lastState, 1);
      expect(lastState2, 0);
    },
  );

  test(
    'dispose closes state stream',
    () async {
      final reState = TestState(0)..dispose();
      await expectLater(reState.stateStream, emitsInOrder([0, emitsDone]));
    },
  );
}
