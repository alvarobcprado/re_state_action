import 'package:flutter/widgets.dart';
import 'package:re_state_action/src/re_state.dart';
import 'package:re_state_action/src/typedefs/re_types.dart';

/// A widget that subscribes to the state changes of the given [reState] and
/// rebuilds itself when the state changes.
///
/// [builder] is called every time the state changes, and it is passed the
/// current [State] and the [child] widget.
///
/// [child] is optional and can be used to optimize the number of times the
/// [builder] is called.
///
/// [builder] is not called when the state is null.
class ReStateWidget<S> extends StatefulWidget {
  /// Creates a [ReStateWidget] that subscribes to the state changes of
  /// the given [reState] and rebuilds itself when the state changes.
  const ReStateWidget({
    Key? key,
    required this.builder,
    required this.reState,
    this.buildWhen,
    this.child,
  }) : super(key: key);

  /// Called every time the state changes.
  final ReStateBuilder<S> builder;

  /// The [ReState] that this widget subscribes to.
  final ReState<S> reState;

  /// A function that verifies if the should or not to call the [builder]
  /// based on the previous and current [State].
  final ReStateBuildCondition<S>? buildWhen;

  /// The child widget that is passed to the [builder].
  final Widget? child;

  @override
  State<ReStateWidget<S>> createState() => _ReStateWidgetState<S>();
}

class _ReStateWidgetState<S> extends State<ReStateWidget<S>> {
  late S _currentState;
  late bool _isFirstBuild;

  @override
  void initState() {
    super.initState();
    _isFirstBuild = true;
    _currentState = widget.reState.state;
    widget.reState.listenState(_listenToStateChange);
  }

  @override
  void dispose() {
    widget.reState.removeStateListener(_listenToStateChange);
    super.dispose();
  }

  void _listenToStateChange(S newState) {
    if (_isFirstBuild) {
      _isFirstBuild = false;
      return;
    }

    if (widget.buildWhen?.call(_currentState, newState) ?? true) {
      setState(() {
        _currentState = newState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _currentState, widget.child);
  }
}
