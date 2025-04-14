import 'package:flutter/material.dart';
import './widgets/row_column_widget.dart';
import './widgets/container_widget.dart';
import './widgets/center_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,   // to remove debug banner (on the right corner of ui)
      home: const WidgetExplorer(),
    );
  }
}

class WidgetExplorer extends StatefulWidget {
  const WidgetExplorer({super.key});

  @override
  State<WidgetExplorer> createState() => _WidgetExplorerState();
}

class _WidgetExplorerState extends State<WidgetExplorer> {
  String selectedWidget = '';

  Widget _getWidgetToDisplay() {
    switch (selectedWidget) {
      case 'Text':
        return const Text(
          "This is a Text Widget",
          style: TextStyle(fontSize: 24),
        );
      case 'Center':
        return const CenterWidget();
      case 'Row,Column and Wrap':
        return RowColumnWidget();
      case 'Container':
        return ContainerWidget();
      default:
        return Text("Flutter Widgets!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Side Navigation
          Container(
            width: 200,
            color: Colors.deepPurple.shade100,
            child: ListView(
              children: [
                _buildNavItem("Center"),
                _buildNavItem("Container"),
                _buildNavItem("Row,Column and Wrap"),
                 _buildNavItem("Text"),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: _getWidgetToDisplay(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String name) {
    return ListTile(
      title: Text(name),
      selected: selectedWidget == name,
      onTap: () {
        setState(() {
          selectedWidget = name;
        });
      },
    );
  }
}
