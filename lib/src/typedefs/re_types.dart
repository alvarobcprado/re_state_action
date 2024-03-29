import 'dart:async';

import 'package:flutter/widgets.dart';

/// A function that builds a widget given the current [State] and the [child].
typedef ReStateBuilder<State> = Widget Function(
  BuildContext context,
  State state,
  Widget? child,
);

/// A function that is called when the [State] changes.
typedef ReStateCallback<State> = FutureOr<void> Function(
  State state,
);

/// A function that is called when an [Action] is dispatched.
typedef ReActionCallback<Action> = FutureOr<void> Function(
  Action action,
);

/// A function that verifies if the should or not to call the [ReStateBuilder]
/// based on the previous and current [State].
typedef ReStateBuildCondition<State> = bool Function(
  State previousState,
  State currentState,
);

/// A function that verifies if the should or not to call the [ReActionCallback]
/// based on the previous and current [Action].
typedef ReActionListenerCondition<Action> = bool Function(
  Action? previousAction,
  Action currentAction,
);

/// A function that maps the [T] to a [Stream] of [T].
typedef ReListenerMapper<T> = Stream<T> Function(T callback);

/// A function that modifies the listener to be called when the [T] changes.
typedef ReListenerModifier<T> = Stream<T> Function(
  Stream<T> listener,
  ReListenerMapper<T> mapper,
);

/// A function that is called when an [Event] is dispatched.
typedef ReEventCallback<Event> = FutureOr<void> Function(
  Event event,
);
