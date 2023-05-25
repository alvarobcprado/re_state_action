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

  void guardIncrement() {
    guardState(
      (lastState) => lastState + 3,
      initialState: 10,
    );
  }

  void guardIncrementError() {
    guardState(
      (lastState) => throw Exception('error'),
      onError: (_) => -1,
    );
  }

  void guardIncrementIgnoreError() {
    guardState(
      (lastState) => throw Exception('error'),
    );
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

class WrongTestStateEvent extends ReStateEvent<int, CounterEvent> {
  WrongTestStateEvent(int initialState) : super(initialState) {
    on<IncrementEvent>((event) => _increment());
    on<IncrementEvent>((event) => _increment());
  }

  void _increment() {
    emitState(state + 1);
  }
}

abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DispatchActionEvent extends CounterEvent {}

class NotRegisteredEvent extends CounterEvent {}
