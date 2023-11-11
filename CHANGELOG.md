## 1.1.0
* Updated `ReListenerModifier` approach

## 1.0.1
* Added `guardState` method to `ReState` to allow safe emitting of state changes without try-catch blocks

## 1.0.0
* Bumped version to 1.0.0 stable release

## 0.0.13
* Updated readme documentation with Dart 3 example
* Fixed `ReStateActionWidget` doc
* Fixed `ReStateWidget` doc
* Fixed `ReActionListener` doc

## 0.0.12
* Refactored `ReStateActionWidget` to remove duplicated code with `ReStateWidget`

## 0.0.11
* Created `ReListenerModifiers` library to hold all listener modifiers

## 0.0.10
* Improved error handling

## 0.0.9
* Added `ReStateEvent` and `ReStateActionEvent` to allow for more granular control over the events that are dispatched from the view

## 0.0.8
* Added `ReListenerModifier` to allow for more granular control over when to listen to actions or state changes

## 0.0.7
* Added `ReStateBuildCondition` to allow for more granular control over when to rebuild widgets
* Added `ReActionListenerCondition` to allow for more granular control over when to listen to actions

## 0.0.6
* Changed actionNotifier type to PublishSubject

## 0.0.5
* Added readme documentation

## 0.0.4
* Added unit and widget tests

## 0.0.3
* Added initial documentation
* Adjust ReStateWidget property to use ReState instead of ReStateAction

## 0.0.2
* Added example app to demonstrate usage
* Downgraded of dart min sdk version to 2.12.0

## 0.0.1
* Initial release
