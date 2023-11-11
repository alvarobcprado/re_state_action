import 'package:flutter/foundation.dart';
import 'package:re_state_action/re_state_action.dart';
import 'package:re_state_action/src/utils/re_listener_utils.dart';
import 'package:re_state_action/src/utils/re_subscription_holder.dart';
import 'package:rxdart/rxdart.dart';

/// A mixin that provides the functionality to listen to the events dispatched.
mixin ReEventMixin<Event> on ReSubscriptionHolder {
  final Map<Type, Function> _eventsMap = {};
  late final PublishSubject<Event> _eventsNotifier;
  bool _isInitialized = false;
  bool get _isClosed => _eventsNotifier.isClosed;

  /// Initializes the events notifier.
  @protected
  void initEvent() {
    _eventsNotifier = PublishSubject<Event>();
    _isInitialized = true;
  }

  /// Listens to the events of subtype [T] that are dispatched.
  ///
  /// Throws an exception if an event of type [T] already has a listener.
  ///
  /// [callback] is called whenever an event of type [T] is dispatched.
  ///
  /// [modifier] is used to modify the stream of events before it is listened.
  @protected
  void on<T extends Event>(
    ReEventCallback<T> callback, {
    ReListenerModifier<T>? modifier,
  }) {
    if (!_isInitialized) {
      throw StateError(
        'on() called before initEvent(). '
        'Make sure to call initEvent() in the constructor of the class.',
      );
    }

    if (_isClosed) {
      throw StateError(
        'on() called after closeEvent(). '
        'Make sure to call closeEvent() in the dispose() method of the class.',
      );
    }

    final type = T;
    if (_eventsMap.containsKey(type)) {
      throw StateError(
        'on() called more than once for event of type $type. '
        'Make sure to call on<$type>() only once.',
      );
    }
    _eventsMap[type] = callback;

    final stream = _eventsNotifier.stream.whereType<T>();
    final listenerModifier = modifier ?? reListenerModifier();
    final listenerMapper = reListenerMapper(callback);

    final subscription = subscriptions.add(
      listenerModifier(stream, listenerMapper).listen(null),
    );

    subscriptions.add(subscription);
  }

  /// Dispatches the given [event].
  void process(Event event) {
    if (!_isInitialized) {
      throw StateError(
        'process() called before initEvent(). '
        'Make sure to call initEvent() in the constructor of the class.',
      );
    }

    if (_isClosed) {
      throw StateError(
        'process() called after closeEvent(). '
        'Make sure to call closeEvent() in the dispose() method of the class.',
      );
    }

    final type = event.runtimeType;

    if (!_eventsMap.containsKey(type)) {
      throw StateError(
        'No handler found for event of type $type. '
        'Make sure to call on<$type>() before process the event.',
      );
    }

    _eventsNotifier.add(event);
  }

  /// Closes the events notifier.
  @protected
  @mustCallSuper
  void closeEvent() {
    _eventsNotifier.close();
    _eventsMap.clear();
  }
}
