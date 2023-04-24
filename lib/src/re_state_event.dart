import 'package:flutter/foundation.dart';
import 'package:re_state_action/src/mixins/re_event_mixin.dart';
import 'package:re_state_action/src/re_state.dart';

/// A class that manages the state of the application and provides a stream of
/// state changes.
///
/// It also provides a handler for events of type [Event] dispatched from the
/// view using the [process] method.
abstract class ReStateEvent<State, Event> extends ReState<State>
    with ReEventMixin<Event> {
  /// Creates a [ReStateEvent] with the given [initialState].
  ReStateEvent(State initialState) : super(initialState) {
    initEvent();
  }

  /// Disposes the [ReStateEvent] and closes all the streams and subscriptions.
  @mustCallSuper
  @override
  void dispose() {
    closeEvent();
    super.dispose();
  }
}
