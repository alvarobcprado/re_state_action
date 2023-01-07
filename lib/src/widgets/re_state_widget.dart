import 'package:flutter/widgets.dart';
import 'package:re_state_action/src/re_state_action.dart';
import 'package:re_state_action/src/typedefs/re_types.dart';

class ReStateWidget<S> extends StatelessWidget {
  const ReStateWidget({
    super.key,
    required this.builder,
    required this.reState,
    this.child,
  });

  final ReStateBuilder<S> builder;
  final ReStateAction<S, Object> reState;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      stream: reState.stateStream,
      builder: (context, state) {
        if (state.hasData) {
          return builder(context, state.data as S, child);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
