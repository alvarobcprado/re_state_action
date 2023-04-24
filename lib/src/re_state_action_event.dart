import 'package:flutter/foundation.dart';
import 'package:re_state_action/re_state_action.dart';
import 'package:re_state_action/src/mixins/re_event_mixin.dart';

/// A class that manages the state of the application and provides a stream of
/// state changes. It also provides a stream of actions that can be used to
/// dispatch actions to the view.
///
/// It also provides a handler to process events of type [Event] dispatched from
/// view using the [process] method.
abstract class ReStateActionEvent<State, Action, Event>
    extends ReStateAction<State, Action> with ReEventMixin<Event> {
  /// Creates a [ReStateAction] with the given [initialState].
  ReStateActionEvent(State initialState) : super(initialState) {
    initEvent();
  }

  /// Disposes the [ReStateAction] and closes all the streams and subscriptions.
  @mustCallSuper
  @override
  void dispose() {
    closeEvent();
    super.dispose();
  }
}
