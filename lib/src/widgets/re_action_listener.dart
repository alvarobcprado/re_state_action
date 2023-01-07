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
    required this.child,
  }) : super(key: key);

  /// Called every time an action is dispatched.
  final ReActionCallback<A> onAction;

  /// The [ReStateAction] that this widget subscribes to.
  final ReStateAction<dynamic, A> reState;

  /// The child widget that is not rebuilt when an action is dispatched.
  final Widget child;

  @override
  State<ReActionListener<A>> createState() => _ReActionListenerState<A>();
}

class _ReActionListenerState<A> extends State<ReActionListener<A>> {
  ReStateAction<dynamic, A> get reState => widget.reState;

  @override
  void initState() {
    super.initState();
    reState.listenAction(widget.onAction);
  }

  @override
  void dispose() {
    reState.removeActionListener(widget.onAction);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
