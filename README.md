<div style="text-align: center; font-family: times new roman">
<h1><span style="color:#7e71ac"><strong>Re</strong></span>:StateAction</h1>
  <a href="https://pub.dev/packages/re_state_action"><img src="https://img.shields.io/pub/v/re_state_action.svg" alt="Pub.dev Badge"></a>
	<a href="https://github.com/alvarobcprado/re_state_action/actions"><img src="https://github.com/alvarobcprado/re_state_action/actions/workflows/test.yml/badge.svg" alt="GitHub Build Badge"></a>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>

</div>

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
