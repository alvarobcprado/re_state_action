import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  test(
    'initialize with initial state',
    () {
      final reState = TestStateAction(0);
      expect(reState.state, 0);
    },
  );

  test(
    'emit new state updates current state',
    () {
      final reState = TestStateAction(0)..increment();
      expect(reState.state, 1);
    },
  );

  test(
    'emit action',
    () async {
      final reState = TestStateAction(0)..dispatchAction();
      await expectLater(reState.actionStream, emits('action'));
    },
  );

  test(
    'listen to state updates',
    () async {
      final reState = TestStateAction(0);
      var lastState = 0;
      var lastAction = 'test';

      reState
        ..listenState((state) {
          lastState = state;
        })
        ..listenAction((action) {
          lastAction = '$lastAction $action';
        })
        ..increment()
        ..dispatchAction();

      await expectLater(reState.stateStream, emits(1));
      await expectLater(reState.actionStream, emits('action'));
      expect(lastState, 1);
      expect(lastAction, 'test action');
    },
  );

  test(
    'remove listener from state updates',
    () async {
      final reState = TestStateAction(0);
      var lastState = 0;
      var lastAction = 'test';

      void listenerToRemove(String action) {
        lastAction = '$lastAction $action';
      }

      reState
        ..listenState((state) {
          lastState = state;
        })
        ..listenAction(listenerToRemove)
        ..removeActionListener(listenerToRemove)
        ..increment()
        ..dispatchAction();

      await expectLater(reState.stateStream, emits(1));
      await expectLater(reState.actionStream, emits('action'));
      expect(lastState, 1);
      expect(lastAction, 'test');
    },
  );

  test(
    'dispose closes state and action streams',
    () async {
      final reState = TestStateAction(0)..dispose();
      await expectLater(reState.stateStream, emitsInOrder([0, emitsDone]));
      await expectLater(reState.actionStream, emitsInOrder([emitsDone]));
    },
  );
}
