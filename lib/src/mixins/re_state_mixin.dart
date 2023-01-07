// ignore_for_file: cancel_subscriptions

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:re_state_action/src/typedefs/re_types.dart';
import 'package:re_state_action/src/utils/re_subscription_holder.dart';
import 'package:rxdart/rxdart.dart';

mixin ReStateMixin<State> on ReSubscriptionHolder {
  @protected
  late final BehaviorSubject<State> stateNotifier;

  State get state => stateNotifier.value;
  Stream<State> get stateStream => stateNotifier.stream;
  final Map<ReStateCallback<State>, StreamSubscription<State>>
      _stateSubscriptions = {};

  @protected
  void emitState(State state) {
    stateNotifier.add(state);
  }

  void listenState(
    ReStateCallback<State> listener, {
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    final subscription = subscriptions.add(
      stateNotifier.listen(
        listener,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      ),
    );

    _stateSubscriptions[listener] = subscription;
  }

  void removeStateListener(ReStateCallback<State> listener) {
    final subscription = _stateSubscriptions.remove(listener);
    if (subscription != null) {
      subscription.cancel();
    }
  }

  @protected
  @mustCallSuper
  void closeState() {
    stateNotifier.close();
    _stateSubscriptions.forEach(
      (key, value) {
        value.cancel();
      },
    );
  }
}
