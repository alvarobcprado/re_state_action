import 'package:flutter/widgets.dart';
import 'package:re_state_action/src/re_state_action.dart';
import 'package:re_state_action/src/typedefs/re_types.dart';

class ReStateActionWidget<S, A> extends StatefulWidget {
  const ReStateActionWidget({
    super.key,
    required this.builder,
    required this.reState,
    required this.onAction,
    this.child,
  });

  final ReStateBuilder<S> builder;
  final ReActionCallback<A> onAction;
  final ReStateAction<S, A> reState;
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
