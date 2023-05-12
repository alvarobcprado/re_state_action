import 'package:flutter/widgets.dart';
import 'package:re_state_action/re_state_action.dart';

/// A widget that subscribes to the changes of state and actions of the given
/// [reState] and rebuilds itself when the state changes.
/// When an action is dispatched, the [onAction] callback is called.
///
/// [builder] is called every time the state changes, and it is passed the
/// current [State] and the [child] widget.
///
/// [child] is optional and can be used to optimize the number of times the
/// [builder] is called.
///
/// [builder] is not called when the state is null.
class ReStateActionWidget<S, A> extends StatelessWidget {
  /// Creates a [ReStateActionWidget] that subscribes to the changes of state
  /// and actions of the given [reState] and rebuilds itself when the state
  /// changes.
  /// When an action is dispatched, the [onAction] callback is called.
  const ReStateActionWidget({
    Key? key,
    required this.builder,
    required this.reState,
    required this.onAction,
    this.listenWhen,
    this.buildWhen,
    this.child,
  }) : super(key: key);

  /// Called every time the state changes.
  final ReStateBuilder<S> builder;

  /// Called every time an action is dispatched.
  final ReActionCallback<A> onAction;

  /// The [ReStateAction] that this widget subscribes to.
  final ReStateAction<S, A> reState;

  /// A function that verifies if the should or not to call the [onAction]
  /// based on the previous and current [Action].
  final ReActionListenerCondition<A>? listenWhen;

  /// A function that verifies if the should or not to rebuild the widget
  /// based on the previous and current [State].
  final ReStateBuildCondition<S>? buildWhen;

  /// The child widget that is passed to the [builder].
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ReActionListener(
      reState: reState,
      onAction: onAction,
      listenWhen: listenWhen,
      child: ReStateWidget(
        reState: reState,
        buildWhen: buildWhen,
        builder: builder,
        child: child,
      ),
    );
  }
}
