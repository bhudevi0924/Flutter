import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HookWidgetLifecycleHooks extends HookWidget {

  const HookWidgetLifecycleHooks({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = useState(0); // Equivalent to using useState

    // useEffect equivalent to componentDidMount in React
    useEffect(() {
      print('HookWidget: useEffect called - componentDidMount');
      
      return () {
        print('HookWidget: Cleanup (like componentWillUnmount)');
      };
    }, []); // Runs once when the widget is created

    return Scaffold(
      appBar: AppBar(title: Text('HookWidget Lifecycle')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: ${counter.value}'),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                counter.value++; // Modifies the counter state
              },
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
