import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  group(
    'ReStateAction',
    () {
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
          final reState = TestStateAction(0);
          scheduleMicrotask(reState.dispatchAction);
          await expectLater(reState.actionStream, emits('action'));
        },
      );

      test(
        'listen to state updates',
        () async {
          final reState = TestStateAction(0);
          var listenValue = 'test';

          reState
            ..listenState((state) {
              listenValue = 'test $state';
            })
            ..increment();

          await expectLater(reState.stateStream, emits(1));
          expect(listenValue, 'test 1');
        },
      );

      test(
        'listen to action updates',
        () async {
          final reState = TestStateAction(0);
          var listenValue = 'test';

          reState.listenAction((action) {
            listenValue = 'test $action';
          });

          scheduleMicrotask(reState.dispatchAction);

          await expectLater(reState.actionStream, emits('action'));

          expect(listenValue, 'test action');
        },
      );

      test(
        'remove listener from state updates',
        () async {
          final reState = TestStateAction(0);
          var listenValue = 'test';

          void listenerToRemove(int state) {
            listenValue = 'test $state';
          }

          reState
            ..listenState(listenerToRemove)
            ..removeStateListener(listenerToRemove)
            ..increment();

          await expectLater(reState.stateStream, emits(1));
          expect(listenValue, 'test');
        },
      );

      test(
        'remove listener from action updates',
        () async {
          final reState = TestStateAction(0);
          var listenValue = 'test';

          void listenerToRemove(String action) {
            listenValue = 'test $action';
          }

          reState
            ..listenAction(listenerToRemove)
            ..removeActionListener(listenerToRemove);

          scheduleMicrotask(reState.dispatchAction);

          await expectLater(reState.actionStream, emits('action'));
          expect(listenValue, 'test');
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
    },
  );
}
