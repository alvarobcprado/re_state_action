// ignore_for_file: cancel_subscriptions

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:re_state_action/src/typedefs/re_types.dart';
import 'package:re_state_action/src/utils/re_subscription_holder.dart';
import 'package:rxdart/rxdart.dart';

/// A mixin that provides the functionality to listen to the state changes.
/// It also provides a method to emit state.
mixin ReStateMixin<State> on ReSubscriptionHolder {
  late final BehaviorSubject<State> _stateNotifier;

  /// Initializes the state notifier.
  @protected
  void initState(State initialState) {
    _stateNotifier = BehaviorSubject<State>.seeded(initialState);
  }

  /// The current state.
  State get state => _stateNotifier.value;

  /// A stream of state.
  Stream<State> get stateStream => _stateNotifier.stream;
  final Map<ReStateCallback<State>, StreamSubscription<State>>
      _stateSubscriptions = {};

  /// Emits the given [state].
  @protected
  void emitState(State state) {
    _stateNotifier.add(state);
  }

  /// Listens to the state changes.
  ///
  /// [listener] is called whenever a [State] is emitted.
  ///
  /// [modifier] is used to modify the stream of state before it is listened to.
  ///
  /// [onError] is called whenever an error occurs.
  ///
  /// [onDone] is called when the stream is closed.
  ///
  /// [cancelOnError] is used to cancel the subscription when an error occurs.
  void listenState(
    ReStateCallback<State> listener, {
    ReListenerModifier<State>? modifier,
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    final listenerModifier = modifier ?? (listener) => listener;

    final subscription = subscriptions.add(
      listenerModifier(stateStream).listen(
        listener,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      ),
    );

    _stateSubscriptions[listener] = subscription;
  }

  /// Removes the [listener] from the state stream.
  /// If the [listener] is not present in the state stream, then
  void removeStateListener(ReStateCallback<State> listener) {
    final subscription = _stateSubscriptions.remove(listener);
    if (subscription != null) {
      subscription.cancel();
    }
  }

  /// Closes the state notifier.
  /// It also cancels all the subscriptions.
  @protected
  @mustCallSuper
  void closeState() {
    _stateNotifier.close();
    _stateSubscriptions.forEach(
      (key, value) {
        value.cancel();
      },
    );
  }
}
