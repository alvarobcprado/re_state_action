import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  group(
    'ReState',
    () {
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

      test(
        'throw state error when emitState() is called after dispose()',
        () async {
          final reState = TestState(0)..dispose();
          expect(reState.increment, throwsStateError);
        },
      );

      test(
        'throw state error when listenState() is called after dispose()',
        () async {
          final reState = TestState(0)..dispose();
          expect(() => reState.listenState((state) {}), throwsStateError);
        },
      );

      test(
        'guardState with initial state resets old state',
        () async {
          final reState = TestState(0)..increment();
          expect(reState.state, 1);
          reState.guardIncrement();
          await expectLater(reState.stateStream, emitsInOrder([10, 4]));
        },
      );

      test(
        'guardState with callback emits state of callback',
        () async {
          final reState = TestState(0)..guardIncrement();
          await Future<void>.delayed(Duration.zero);
          await expectLater(reState.state, 3);
        },
      );

      test(
        'guardState with callback that throws error emits state of onError',
        () async {
          final reState = TestState(0)..guardIncrementError();
          await Future<void>.delayed(Duration.zero);
          expect(reState.state, -1);
        },
      );

      test(
        'guardState with callback that throws error and has no onError'
        ' does not emit state',
        () async {
          final reState = TestState(0)..guardIncrementIgnoreError();
          await Future<void>.delayed(Duration.zero);
          await expectLater(reState.state, 0);
        },
      );
    },
  );
}
