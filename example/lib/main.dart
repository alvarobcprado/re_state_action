import 'package:flutter/material.dart';
import 'package:re_state_action/re_state_action.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ReStateAction Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter ReStateAction Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ReCounterStateAction _reCounterStateAction = ReCounterStateAction();

  void _incrementCounter() {
    _reCounterStateAction.increment();
  }

  void _onCounterAction(ReCounterAction action) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Snackbar Color: ${action.colorName}'),
          backgroundColor: action.color,
        ),
      );
  }

  void _onResetCounter() {
    _reCounterStateAction.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _onResetCounter,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            ReStateActionWidget(
              reState: _reCounterStateAction,
              onAction: _onCounterAction,
              buildWhen: (previousState, currentState) {
                return currentState < 15;
              },
              builder: (context, state, child) => Text(
                '$state',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ReCounterStateAction extends ReStateAction<int, ReCounterAction> {
  ReCounterStateAction() : super(0) {
    listenState(
      (state) {
        if (state == 0) {
          return;
        } else if (state % 2 == 0) {
          emitAction(const ShowSnackGreen());
        } else {
          emitAction(const ShowSnackRed());
        }
      },
      modifier: (listener) {
        return listener.debounceTime(const Duration(milliseconds: 500));
      },
    );
  }

  void increment() {
    emitState(state + 1);
  }

  void reset() {
    emitState(0);
    emitAction(const ShowSnackBrown());
  }
}

abstract class ReCounterAction {
  const ReCounterAction(
    this.color,
    this.colorName,
  );
  final Color color;
  final String colorName;
}

class ShowSnackRed extends ReCounterAction {
  const ShowSnackRed() : super(Colors.red, 'Red');
}

class ShowSnackGreen extends ReCounterAction {
  const ShowSnackGreen() : super(Colors.green, 'Green');
}

class ShowSnackBrown extends ReCounterAction {
  const ShowSnackBrown() : super(Colors.brown, 'Brown - Reseting');
}
