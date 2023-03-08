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
  State<ReStateActionWidget<S, A>> createState() =>
      _ReStateActionWidgetState<S, A>();
}

class _ReStateActionWidgetState<S, A> extends State<ReStateActionWidget<S, A>> {
  ReStateAction<S, A> get reState => widget.reState;
  late S _currentState;
  late bool _isFirstBuild;

  @override
  void initState() {
    super.initState();
    _currentState = reState.state;
    _isFirstBuild = true;
    reState.listenState(_listenToStateChange);
  }

  @override
  void dispose() {
    reState.removeStateListener(_listenToStateChange);
    super.dispose();
  }

  void _listenToStateChange(S state) {
    if (_isFirstBuild) {
      _isFirstBuild = false;
      return;
    }

    if (widget.buildWhen?.call(_currentState, state) ?? true) {
      setState(() {
        _currentState = state;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReActionListener(
      reState: reState,
      onAction: widget.onAction,
      listenWhen: widget.listenWhen,
      child: widget.builder(context, _currentState, widget.child),
    );
  }
}
