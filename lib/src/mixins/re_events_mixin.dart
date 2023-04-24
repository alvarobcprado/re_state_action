import 'package:flutter/foundation.dart';
import 'package:re_state_action/re_state_action.dart';
import 'package:re_state_action/src/utils/re_subscription_holder.dart';
import 'package:rxdart/rxdart.dart';

mixin ReEventsMixin<Event> on ReSubscriptionHolder {
  final Map<Type, Function> _events = {};
  final PublishSubject<Event> _eventsSubject = PublishSubject<Event>();

  @protected
  void on<T extends Event>(
    ReEventCallback<T> callback, {
    ReListenerModifier<T>? modifier,
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    final type = T;
    if (_events.containsKey(type)) {
      throw Exception('Event $type already subscribed');
    }
    _events[type] = callback;

    final stream = _eventsSubject.stream.whereType<T>();
    final listenerModifier = modifier ?? (stream) => stream;

    final subscription = subscriptions.add(
      listenerModifier(stream).listen(
        callback,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      ),
    );

    subscriptions.add(subscription);
  }

  void process(Event event) {
    _eventsSubject.add(event);
  }
}
