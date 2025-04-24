import 'package:flutter/material.dart';

class StatefulWidgetLifecycleHooks extends StatefulWidget {
  const StatefulWidgetLifecycleHooks({super.key});

  @override
  State<StatefulWidgetLifecycleHooks> createState() => _StatefulWidgetLifecycleHooksState();
}

class _StatefulWidgetLifecycleHooksState extends State<StatefulWidgetLifecycleHooks> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    print('StatefulWidget: initState called');
  }

  @override
  void didUpdateWidget(covariant StatefulWidgetLifecycleHooks oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('StatefulWidget: didUpdateWidget called');
  }

  @override
  void dispose() {
    print('StatefulWidget: dispose called');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('StatefulWidget Lifecycle')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: $_counter'),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _counter++;
                });
              },
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}