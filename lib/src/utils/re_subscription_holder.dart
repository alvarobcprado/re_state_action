import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class ReSubscriptionHolder {
  final subscriptions = CompositeSubscription();

  @protected
  @mustCallSuper
  void closeSubscriptions() {
    subscriptions.dispose();
  }
}
