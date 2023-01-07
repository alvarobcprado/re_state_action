import 'package:flutter/foundation.dart';
import 'package:re_state_action/src/mixins/re_state_mixin.dart';
import 'package:re_state_action/src/utils/re_subscription_holder.dart';
import 'package:rxdart/rxdart.dart';

abstract class ReState<State> extends ReSubscriptionHolder
    with ReStateMixin<State> {
  ReState(State initialState) {
    stateNotifier = BehaviorSubject<State>.seeded(initialState);
  }

  @mustCallSuper
  void dispose() {
    closeState();
    closeSubscriptions();
  }
}
