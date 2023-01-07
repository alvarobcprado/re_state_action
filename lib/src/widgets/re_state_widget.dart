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
class ReStateWidget<State> extends StatelessWidget {
  /// Creates a [ReStateWidget] that subscribes to the state changes of
  /// the given [reState] and rebuilds itself when the state changes.
  const ReStateWidget({
    Key? key,
    required this.builder,
    required this.reState,
    this.child,
  }) : super(key: key);

  /// Called every time the state changes.
  final ReStateBuilder<State> builder;

  /// The [ReState] that this widget subscribes to.
  final ReState<State> reState;

  /// The child widget that is passed to the [builder].
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<State>(
      stream: reState.stateStream,
      builder: (context, state) {
        if (state.hasData) {
          return builder(context, state.data as State, child);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
