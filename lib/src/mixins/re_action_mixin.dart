// ignore_for_file: cancel_subscriptions, lines_longer_than_80_chars

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:re_state_action/src/typedefs/re_types.dart';
import 'package:re_state_action/src/utils/re_subscription_holder.dart';
import 'package:rxdart/rxdart.dart';

/// A mixin that provides the functionality to listen to the action changes.
/// It also provides a method to emit actions.
mixin ReActionMixin<Action> on ReSubscriptionHolder {
  late final PublishSubject<Action> _actionNotifier;
  bool _isInitialized = false;
  bool get _isClosed => _actionNotifier.isClosed;

  /// Initializes the action notifier.
  @protected
  void initAction() {
    _actionNotifier = PublishSubject<Action>();
    _isInitialized = true;
  }

  /// A stream of actions.
  Stream<Action> get actionStream => _actionNotifier.stream;
  final Map<ReActionCallback<Action>, StreamSubscription<Action>>
      _actionSubscriptions = {};

  /// Emits the given [action].
  @protected
  void emitAction(Action action) {
    if (!_isInitialized) {
      throw StateError(
        'emitAction() called before initAction(). '
        'Make sure to call initAction() in the constructor of the class.',
      );
    }

    if (_isClosed) {
      throw StateError(
        'emitAction() called after closeAction(). '
        'Make sure to call closeAction() in the dispose() method of the class.',
      );
    }

    _actionNotifier.add(action);
  }

  /// Listens to the actions changes.
  ///
  /// [listener] is called whenever an [Action] is emitted.
  ///
  /// [modifier] is used to modify the stream of actions before it is listened to.
  ///
  /// [onError] is called whenever an error occurs.
  ///
  /// [onDone] is called when the stream is closed.
  ///
  /// [cancelOnError] is used to cancel the subscription when an error occurs.
  void listenAction(
    ReActionCallback<Action> listener, {
    ReListenerModifier<Action>? modifier,
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    if (!_isInitialized) {
      throw StateError(
        'listenAction() called before initAction(). '
        'Make sure to call initAction() in the constructor of the class.',
      );
    }

    if (_isClosed) {
      throw StateError(
        'listenAction() called after closeAction(). '
        'Make sure to call closeAction() in the dispose() method of the class.',
      );
    }

    final listenerModifier = modifier ?? (listener) => listener;

    final subscription = subscriptions.add(
      listenerModifier(actionStream).listen(
        listener,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      ),
    );
    _actionSubscriptions[listener] = subscription;
  }

  /// Removes the [listener] from the action stream.
  /// It cancels the subscription.
  /// If the [listener] is not present in the action stream, then
  /// it does nothing.
  void removeActionListener(ReActionCallback<Action> listener) {
    if (!_isInitialized) {
      throw StateError(
        'removeActionListener() called before initAction(). '
        'Make sure to call initAction() in the constructor of the class.',
      );
    }

    final subscription = _actionSubscriptions.remove(listener);
    if (subscription != null) {
      subscription.cancel();
    }
  }

  /// Closes the action stream.
  /// It also cancels all the subscriptions.
  @protected
  @mustCallSuper
  void closeAction() {
    _actionNotifier.close();
    _actionSubscriptions.forEach(
      (key, value) {
        value.cancel();
      },
    );
  }
}
