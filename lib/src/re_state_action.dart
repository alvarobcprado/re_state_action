import 'package:flutter/foundation.dart';
import 'package:re_state_action/src/mixins/re_action_mixin.dart';
import 'package:re_state_action/src/re_state.dart';

/// A class that manages the state of the application and provides a stream of
/// state changes. It also provides a stream of actions that can be used to
/// dispatch actions to the view. The actions can be used to trigger events
/// like navigation, showing dialogs, etc.
abstract class ReStateAction<State, Action> extends ReState<State>
    with ReActionMixin<Action> {
  /// Creates a [ReStateAction] with the given [initialState].
  ReStateAction(State initialState) : super(initialState) {
    initAction();
  }

  /// Disposes the [ReStateAction] and closes all the streams and subscriptions.
  @mustCallSuper
  @override
  void dispose() {
    closeAction();
    super.dispose();
  }
}
