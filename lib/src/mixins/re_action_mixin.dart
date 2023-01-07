// ignore_for_file: cancel_subscriptions

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:re_state_action/src/typedefs/re_types.dart';
import 'package:re_state_action/src/utils/re_subscription_holder.dart';
import 'package:rxdart/rxdart.dart';

mixin ReActionMixin<Action> on ReSubscriptionHolder {
  late final BehaviorSubject<Action> actionNotifier;

  Stream<Action> get actionStream => actionNotifier.stream;
  final Map<ReActionCallback<Action>, StreamSubscription<Action>>
      _actionSubscriptions = {};

  @protected
  void emitAction(Action action) {
    actionNotifier.add(action);
  }

  void listenAction(
    ReActionCallback<Action> listener, {
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    final subscription = subscriptions.add(
      actionNotifier.listen(
        listener,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      ),
    );
    _actionSubscriptions[listener] = subscription;
  }

  void removeActionListener(ReActionCallback<Action> listener) {
    final subscription = _actionSubscriptions.remove(listener);
    if (subscription != null) {
      subscription.cancel();
    }
  }

  @protected
  @mustCallSuper
  void closeAction() {
    actionNotifier.close();
    _actionSubscriptions.forEach(
      (key, value) {
        value.cancel();
      },
    );
  }
}
