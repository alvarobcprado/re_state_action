import 'package:flutter_test/flutter_test.dart';

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
        'throws a state error when call on<T> twice with same type T',
        () {
          expect(
            () => WrongTestStateEvent(0),
            throwsStateError,
          );
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

      test(
        'throw state error when process() is called after dispose()',
        () async {
          final reState = TestStateEvent(0)..dispose();
          expect(() => reState.process(IncrementEvent()), throwsStateError);
        },
      );

      test(
        'throw state error when on<T>() is called after dispose()',
        () async {
          final reState = TestStateEvent(0)..dispose();
          // ignore: invalid_use_of_protected_member
          expect(() => reState.on((event) {}), throwsStateError);
        },
      );

      test(
        // ignore: lines_longer_than_80_chars
        'throw state error when proccess() is called for a Event that is not registered',
        () async {
          final reState = TestStateEvent(0);
          expect(() => reState.process(NotRegisteredEvent()), throwsStateError);
        },
      );
    },
  );
}
