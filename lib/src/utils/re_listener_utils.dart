import 'dart:async';

import 'package:re_state_action/re_listener_modifiers.dart';
import 'package:re_state_action/src/typedefs/re_types.dart';

/// @nodoc
ReListenerMapper<T> reListenerMapper<T>(FutureOr<void> Function(T) callback) =>
    (data) {
      final controller = StreamController<T>.broadcast(sync: true);

      Future<void> handleData() async {
        try {
          await callback(data);
        } catch (_) {
          rethrow;
        } finally {
          await controller.done;
        }
      }

      handleData();
      return controller.stream;
    };

/// @nodoc
ReListenerModifier<T> reListenerModifier<T>() => ReListenerModifiers.flatMap();
