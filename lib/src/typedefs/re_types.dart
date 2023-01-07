import 'package:flutter/widgets.dart';

typedef ReStateBuilder<State> = Widget Function(
  BuildContext context,
  State state,
  Widget? child,
);

typedef ReStateCallback<State> = void Function(
  State state,
);

typedef ReActionCallback<Action> = void Function(
  Action action,
);
