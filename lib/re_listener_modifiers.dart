library re_listener_modifiers;

import 'package:re_state_action/src/typedefs/re_types.dart';
import 'package:rxdart/transformers.dart';

export 'package:rxdart/transformers.dart';

/// A collection of static methods that return [ReListenerModifier] functions.
/// These functions can be used to modify the behavior of a
/// [ReListenerModifier].
abstract class ReListenerModifiers {
  /// Returns a [ReListenerModifier] that applies a mapper function to the
  /// listener and returns the flattened result.
  static ReListenerModifier<T> flatMap<T>() =>
      (listener, mapper) => listener.flatMap(mapper);

  /// Returns a [ReListenerModifier] that applies a mapper function to the
  /// listener and returns the result of the latest mapped stream.
  static ReListenerModifier<T> switchMap<T>() =>
      (listener, mapper) => listener.switchMap(mapper);

  /// Returns a [ReListenerModifier] that applies a mapper function to the
  /// listener and ignores all events until the mapper completes.
  static ReListenerModifier<T> exhaustMap<T>() =>
      (listener, mapper) => listener.exhaustMap(mapper);

  /// Returns a [ReListenerModifier] that applies a mapper function to the
  /// listener and returns the result of the mapped stream as soon as it is
  /// available.
  static ReListenerModifier<T> asyncExpand<T>() =>
      (listener, mapper) => listener.asyncExpand(mapper);

  /// Returns a [ReListenerModifier] that applies a [Duration] [duration] to
  /// the listener and debounces the events.
  static ReListenerModifier<T> debounceTime<T>(Duration duration) =>
      (listener, mapper) => listener.debounceTime(duration).flatMap(mapper);

  /// Returns a [ReListenerModifier] that applies a [Duration] [duration] to
  ///  the listener and throttles the events.
  static ReListenerModifier<T> throttleTime<T>(Duration duration) =>
      (listener, mapper) => listener.throttleTime(duration).flatMap(mapper);
}
