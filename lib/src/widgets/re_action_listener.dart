import 'package:flutter/widgets.dart';
import 'package:re_state_action/src/re_state_action.dart';
import 'package:re_state_action/src/typedefs/re_types.dart';

/// A widget that subscribes to the action changes of the given [reState] and
/// calls the [onAction] callback when an action is dispatched.
/// The [child] widget is not rebuilt when an action is dispatched.
class ReActionListener<A> extends StatefulWidget {
  /// Creates a [ReActionListener] that subscribes to the action changes of the
  /// given [reState] and calls the [onAction] callback when an action is
  /// dispatched.
  const ReActionListener({
    Key? key,
    required this.reState,
    required this.onAction,
    this.listenWhen,
    required this.child,
  }) : super(key: key);

  /// Called every time an action is dispatched.
  final ReActionCallback<A> onAction;

  /// The [ReStateAction] that this widget subscribes to.
  final ReStateAction<dynamic, A> reState;

  /// A function that verifies if the should or not to call the [onAction]
  /// based on the previous and current [Action].
  final ReActionListenerCondition<A>? listenWhen;

  /// The child widget that is not rebuilt when an action is dispatched.
  final Widget child;

  @override
  State<ReActionListener<A>> createState() => _ReActionListenerState<A>();
}

class _ReActionListenerState<A> extends State<ReActionListener<A>> {
  ReStateAction<dynamic, A> get reState => widget.reState;
  A? _previousAction;

  @override
  void initState() {
    super.initState();
    reState.listenAction(_listenToActionChange);
  }

  @override
  void dispose() {
    reState.removeActionListener(_listenToActionChange);
    super.dispose();
  }

  void _listenToActionChange(A action) {
    if (widget.listenWhen?.call(_previousAction, action) ?? true) {
      widget.onAction(action);
    }
    _previousAction = action;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
