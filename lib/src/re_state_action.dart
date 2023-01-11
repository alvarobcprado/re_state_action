import 'package:flutter/foundation.dart';
import 'package:re_state_action/src/mixins/re_action_mixin.dart';
import 'package:re_state_action/src/mixins/re_state_mixin.dart';
import 'package:re_state_action/src/utils/re_subscription_holder.dart';
import 'package:rxdart/rxdart.dart';

/// A class that manages the state of the application and provides a stream of
/// state changes. It also provides a stream of actions that can be used to
/// dispatch actions to the view. The actions can be used to trigger events
/// like navigation, showing dialogs, etc.
abstract class ReStateAction<State, Action> extends ReSubscriptionHolder
    with ReStateMixin<State>, ReActionMixin<Action> {
  /// Creates a [ReStateAction] with the given [initialState].
  ReStateAction(State initialState) {
    stateNotifier = BehaviorSubject<State>.seeded(initialState);
    actionNotifier = PublishSubject<Action>();
  }

  /// Disposes the [ReStateAction] and closes all the streams and subscriptions.
  @mustCallSuper
  void dispose() {
    closeAction();
    closeState();
    closeSubscriptions();
  }
}
