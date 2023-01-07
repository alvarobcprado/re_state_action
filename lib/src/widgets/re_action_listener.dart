import 'package:flutter/widgets.dart';
import 'package:re_state_action/src/re_state_action.dart';
import 'package:re_state_action/src/typedefs/re_types.dart';

class ReActionListener<A> extends StatefulWidget {
  const ReActionListener({
    Key? key,
    required this.reState,
    required this.onAction,
    required this.child,
  }) : super(key: key);

  final ReActionCallback<A> onAction;
  final ReStateAction<dynamic, A> reState;
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
