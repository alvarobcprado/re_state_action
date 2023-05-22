<div style="text-align: center; font-family: times new roman">
<h1><span style="color:#7e71ac"><strong>Re</strong></span>:StateAction</h1>
  <a href="https://pub.dev/packages/re_state_action"><img src="https://img.shields.io/pub/v/re_state_action.svg" alt="Pub.dev Badge"></a>
	<a href="https://github.com/alvarobcprado/re_state_action/actions"><img src="https://github.com/alvarobcprado/re_state_action/actions/workflows/test.yml/badge.svg" alt="GitHub Build Badge"></a>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
  <a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="Very Good Analysis Style Badge"></a>

</div>

## About

This package acts as a wrapper for the popular [RxDart] library, simplifying state management through streams. It offers a straightforward solution to effectively handle application state and seamlessly manage interactions between the user interface (UI) and the user. By leveraging the package's reactive approach, you can efficiently handle UI components such as dialogs, alerts, modals, and more, all while avoiding unnecessary state overload.

## Usage

To create a simple ReStateAction class:

```dart
abstract class ShowSnackbarAction{}

class ShowIsEvenValueSnackbarAction extends ShowSnackbarAction{}

class CounterStateAction extends ReStateAction<int, ShowSnackbarAction> {
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

In this example, we utilize the package to create a `CounterStateAction` class, responsible for managing the state of a counter by extending the `ReStateAction` class.

Within the class constructor, a listener is set up to monitor state changes. When the state becomes even, an action of type `ShowIsEvenValueSnackbarAction` is emitted using the `emitAction` method. This allows you to handle the event and display a snackbar or perform other actions as needed.

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

## Dart 3.0

The package is compatible with Dart 3.0 new features like sealed classes and pattern matching. To use it, you need to update your Flutter version to `3.10.0` or above and enable the Dart 3.0 features in your `pubspec.yaml` file.

```yaml
environment:
  sdk: ">=3.0.0 <4.0.0"
```

An usecase example:

```dart
sealed class ShowSnackbarAction{}

class ShowIsEvenValueSnackbarAction extends ShowSnackbarAction{}

class ShowIsOddValueSnackbarAction extends ShowSnackbarAction{}

class CounterStateAction extends ReStateAction<int, ShowSnackbarAction> {
  CounterStateAction({int initialState = 0}) : super(initialState){
    // Here you can add the listeners to the state
    listenState((state){
        if(state.isEven){
         emitAction(ShowIsEvenValueSnackbarAction());
        }else{
         emitAction(ShowIsOddValueSnackbarAction());
        }
    });
  }

  void increment() => emitState(state + 1);
  void decrement() => emitState(state - 1);
}

//... in the UI
ReActionListener<ShowSnackbarAction>(
  reState: counterStateAction,
  onAction: (action) {
    final snackbarText = switch (action) {
          ShowIsEvenValueSnackbarAction() => 'The value is even',
          ShowIsOddValueSnackbarAction() => 'The value is odd',
          _ => 'The value is null',
        };
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackbarText),
      ),
    );
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
