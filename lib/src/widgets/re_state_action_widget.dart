import 'package:flutter/widgets.dart';
import 'package:re_state_action/src/re_state_action.dart';
import 'package:re_state_action/src/typedefs/re_types.dart';

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
class ReStateActionWidget<S, A> extends StatefulWidget {
  /// Creates a [ReStateActionWidget] that subscribes to the changes of state
  /// and actions of the given [reState] and rebuilds itself when the state
  /// changes.
  /// When an action is dispatched, the [onAction] callback is called.
  const ReStateActionWidget({
    Key? key,
    required this.builder,
    required this.reState,
    required this.onAction,
    this.child,
  }) : super(key: key);

  /// Called every time the state changes.
  final ReStateBuilder<S> builder;

  /// Called every time an action is dispatched.
  final ReActionCallback<A> onAction;

  /// The [ReStateAction] that this widget subscribes to.
  final ReStateAction<S, A> reState;

  /// The child widget that is passed to the [builder].
  final Widget? child;

  @override
  State<ReStateActionWidget<S, A>> createState() =>
      _ReStateActionWidgetState<S, A>();
}

class _ReStateActionWidgetState<S, A> extends State<ReStateActionWidget<S, A>> {
  ReStateAction<S, A> get reState => widget.reState;

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
    return StreamBuilder<S>(
      stream: reState.stateStream,
      builder: (context, state) {
        if (state.hasData) {
          return widget.builder(context, state.data as S, widget.child);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
