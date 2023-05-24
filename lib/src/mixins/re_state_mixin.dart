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
  bool _isInitialized = false;
  bool get _isClosed => _stateNotifier.isClosed;

  /// Initializes the state notifier.
  @protected
  void initState(State initialState) {
    _stateNotifier = BehaviorSubject<State>.seeded(initialState);
    _isInitialized = true;
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
    if (!_isInitialized) {
      throw StateError(
        'emitState() called before initState(). '
        'Make sure to call initState() in the constructor of the class.',
      );
    }

    if (_isClosed) {
      throw StateError(
        'emitState() called after closeState(). '
        'Make sure to call closeState() in the dispose() method of the class.',
      );
    }

    _stateNotifier.add(state);
  }

  @protected
  Future<void> guardState(
    FutureOr<State> Function(State lastState) callback, {
    required FutureOr<State> Function(State lastState, Object? error) onError,
    State? initialState,
  }) async {
    final lastState = state;

    if (initialState != null) {
      emitState(initialState);
    }

    try {
      emitState(await callback(lastState));
    } catch (error) {
      emitState(await onError(lastState, error));
    }
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
    if (!_isInitialized) {
      throw StateError(
        'listenState() called before initState(). '
        'Make sure to call initState() in the constructor of the class.',
      );
    }

    if (_isClosed) {
      throw StateError(
        'listenState() called after closeState(). '
        'Make sure to call closeState() in the dispose() method of the class.',
      );
    }

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
