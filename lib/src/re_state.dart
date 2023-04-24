import 'package:flutter/foundation.dart';
import 'package:re_state_action/src/mixins/re_state_mixin.dart';
import 'package:re_state_action/src/utils/re_subscription_holder.dart';

/// A class that manages the state of the application and provides a stream of
/// state changes.
abstract class ReState<State> extends ReSubscriptionHolder
    with ReStateMixin<State> {
  /// Creates a [ReState] with the given [initialState].
  ReState(State initialState) {
    initState(initialState);
  }

  /// Disposes the [ReState] and closes all the streams and subscriptions.
  @mustCallSuper
  void dispose() {
    closeState();
    closeSubscriptions();
  }
}
