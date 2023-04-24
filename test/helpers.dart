import 'package:re_state_action/re_state_action.dart';

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

class TestStateEvent extends ReStateEvent<int, CounterEvent> {
  TestStateEvent(int initialState) : super(initialState) {
    on<IncrementEvent>((event) => _increment());
  }

  void _increment() {
    emitState(state + 1);
  }
}

class TestStateActionEvent
    extends ReStateActionEvent<int, String, CounterEvent> {
  TestStateActionEvent(int initialState) : super(initialState) {
    on<IncrementEvent>((event) => _increment());
    on<DispatchActionEvent>((event) => _dispatchAction());
  }

  void _increment() {
    emitState(state + 1);
  }

  void _dispatchAction() {
    emitAction('action');
  }
}

abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DispatchActionEvent extends CounterEvent {}
