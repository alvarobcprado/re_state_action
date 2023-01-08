import 'package:re_state_action/src/re_state.dart';
import 'package:re_state_action/src/re_state_action.dart';

class TestStateAction extends ReStateAction<int, String> {
  TestStateAction(int initialState) : super(initialState);

  void increment() {
    emitState(state + 1);
  }

  void dispatchAction() {
    emitAction('action');
  }
}

class TestState extends ReState<int> {
  TestState(int initialState) : super(initialState);

  void increment() {
    emitState(state + 1);
  }
}
