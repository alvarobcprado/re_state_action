import 'package:flutter/widgets.dart';

/// A function that builds a widget given the current [State] and the [child].
typedef ReStateBuilder<State> = Widget Function(
  BuildContext context,
  State state,
  Widget? child,
);

/// A function that is called when the [State] changes.
typedef ReStateCallback<State> = void Function(
  State state,
);

/// A function that is called when an [Action] is dispatched.
typedef ReActionCallback<Action> = void Function(
  Action action,
);
