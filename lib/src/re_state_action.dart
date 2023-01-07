import 'package:flutter/foundation.dart';
import 'package:re_state_action/src/mixins/re_action_mixin.dart';
import 'package:re_state_action/src/mixins/re_state_mixin.dart';
import 'package:re_state_action/src/utils/re_subscription_holder.dart';
import 'package:rxdart/rxdart.dart';

abstract class ReStateAction<State, Action> extends ReSubscriptionHolder
    with ReStateMixin<State>, ReActionMixin<Action> {
  ReStateAction(State initialState) {
    stateNotifier = BehaviorSubject<State>.seeded(initialState);
    actionNotifier = BehaviorSubject<Action>();
  }

  @mustCallSuper
  void dispose() {
    closeAction();
    closeState();
    closeSubscriptions();
  }
}
