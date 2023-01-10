
<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

## About

This package is a wrapper of [RxDart] library. It provides a simple way to manage the state of your application with the help of streams.
And it also provides a simple way to manage the interaction between the UI and the user (like dialogs, alerts, modals, etc.) in a reactive way and without overloading the state.

## Usage

To create a simple ReStateAction class:

```dart
abstract class ShowSnackbarAction{}

class ShowIsEvenValueSnackbarAction extends ShowSnackbarAction{}

class CounterStateAction extends ReStateAction<int, String> {
  CounterStateAction({int initialState = 0}) : super(initialState){
    // Here you can add the listeners to the state
    listenState((state){
        if(state.isEven){
         emitAction(ShowIsEvenValueSnackbarAction());
        }
    });
  }

  void increment() => emitState(state + 1);
  void decrement() => emitState(state - 1);
}
```

In the example above, we have created a simple [ReStateAction] class that manages the state of a counter. We have also added a listener to the state that will emit an action when the state is even.

When using to manage simple states, instead to use the [ReStateAction] class, we can use the [ReState] class. It is a simple class that manages the state of your application. It is useful when you don't need to manage the interaction between the UI and the user.

To create a simple [ReState] class:

```dart
class CounterReState extends ReState<int> {
  CounterReState({int initialState = 0}) : super(initialState);

  void increment() => emitState(state + 1);
  void decrement() => emitState(state - 1);
}
```

We can access the state using the [state] getter or accessing the stream using the [stateStream] getter. The actions are accessed only using the [actionStream] property. Both state and actions are streams and can be listened using the [listenState] and [listenAction] methods.

To use the [ReState] class in the UI, we can use the [ReStateWidget]. It is a widget that rebuilds the UI when the state changes.

```dart
ReStateWidget<int>(
  reState: counterReState,
  builder: (context, state) {
    return Text('$state');
  },
),
```

To use the [ReStateAction] class in the UI, we can use the [ReStateActionWidget]. It is a widget that rebuilds the UI when the state changes and also listens to the actions.

```dart
ReStateActionWidget<int, ShowSnackbarAction>(
  reState: counterReStateAction,
  onAction: (action) {
    if (action is ShowIsEvenValueSnackbarAction) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The value is even'),
        ),
      );
    }
  },
  builder: (context, state, child) {
    return Column(
      children: [
        Text('Current value: $state'),
        TextButton(
          onPressed: () => counterReStateAction.increment(),
          child: Text('Increment'),
        ),
        TextButton(
          onPressed: () => counterReStateAction.decrement(),
          child: Text('Decrement'),
        ),
      ],
    );
  },
),
```

If we need only to listen to the actions, we can use the [ReActionListener] widget.

```dart
ReActionListener<ShowSnackbarAction>(
  reState: counterStateAction,
  onAction: (action) {
    if (action is ShowIsEvenValueSnackbarAction) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The value is even'),
        ),
      );
    }
  },
  child: Text('Widget that will not be rebuilt'),
),
```

## Example

To see a complete example, see the [ReStateAction Example](https://github.com/alvarobcprado/re_state_action/tree/main/example) folder.

## Contributing

We welcome contributions to this package. If you would like to contribute, please feel free to open an issue or a pull request.

## License

ReStateAction is licensed under the MIT License. See the [LICENSE](https://github.com/alvarobcprado/re_state_action/blob/main/LICENSE) for details.

<!-- TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more. -->
