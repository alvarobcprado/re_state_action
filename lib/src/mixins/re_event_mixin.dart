import 'package:flutter/foundation.dart';
import 'package:re_state_action/re_state_action.dart';
import 'package:re_state_action/src/utils/exceptions.dart';
import 'package:re_state_action/src/utils/re_subscription_holder.dart';
import 'package:rxdart/rxdart.dart';

/// A mixin that provides the functionality to listen to the events dispatched.
mixin ReEventMixin<Event> on ReSubscriptionHolder {
  final Map<Type, Function> _eventsMap = {};
  late final PublishSubject<Event> _eventsNotifier;

  /// Initializes the events notifier.
  @protected
  void initEvent() {
    _eventsNotifier = PublishSubject<Event>();
  }

  /// Listens to the events of subtype [T] that are dispatched.
  ///
  /// Throws an exception if an event of type [T] already has a listener.
  ///
  /// [callback] is called whenever an event of type [T] is dispatched.
  ///
  /// [modifier] is used to modify the stream of events before it is listened.
  ///
  /// [onError] is called whenever an error occurs.
  ///
  /// [onDone] is called when the stream is closed.
  ///
  /// [cancelOnError] is used to cancel the subscription when an error occurs.
  @protected
  void on<T extends Event>(
    ReEventCallback<T> callback, {
    ReListenerModifier<T>? modifier,
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    final type = T;
    if (_eventsMap.containsKey(type)) {
      throw ReDuplicateEventHandlerException(type);
    }
    _eventsMap[type] = callback;

    final stream = _eventsNotifier.stream.whereType<T>();
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

  /// Dispatches the given [event].
  void process(Event event) {
    _eventsNotifier.add(event);
  }

  /// Closes the events notifier.
  @protected
  @mustCallSuper
  void closeEvent() {
    _eventsNotifier.close();
  }
}
