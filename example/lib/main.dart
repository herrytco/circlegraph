import 'package:circlegraph_example/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:circlegraph/circlegraph.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circlegraph Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CircleGraphDemo(),
    );
  }
}

class CircleGraphDemo extends StatefulWidget {
  CircleGraphDemo({Key key}) : super(key: key);

  @override
  _CircleGraphDemoState createState() => _CircleGraphDemoState();
}

class _CircleGraphDemoState extends State<CircleGraphDemo> {
  int numberOfChildren = 0;

  ///
  /// increase the number of child-nodes in the graph by 1
  ///
  void onAdd() {
    setState(() {
      numberOfChildren++;
    });
  }

  ///
  /// decrease the number of child-nodes in the graph by 1
  ///
  void onRemove() {
    if (numberOfChildren > 0)
      setState(() {
        numberOfChildren--;
      });
  }

  ///
  /// generate a simple node that holds an integer with a text inside that
  /// contains its index
  ///
  TreeNodeData _nodeWithIndex(int i) {
    return TreeNodeData<int>(
      child: Text(
        "child $i",
        style: TextStyle(color: ColorPicker.color3),
      ),
      data: i,
      onNodeClick: _onNodeClick,
      backgroundColor: ColorPicker.color2,
    );
  }

  ///
  /// Build the tooltip based on the node that is currently hovered
  ///
  Widget buildTooltip(TreeNodeData node, int data) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: ColorPicker.color4,
      ),
      child: Text(
        "Hovering over node $data",
      ),
    );
  }

  ///
  /// callback when a node is clicked
  ///
  void _onNodeClick(TreeNodeData node, int data) {
    print("clicked on node $data");
  }

  ///
  /// creates a tree with [numberOfChildren] nodes in the circle and one in the
  /// middle.
  ///
  CircleGraph constructTree(
    int numberOfChildren, {
    Color color = Colors.blue,
    double radius = 50,
  }) {
    return CircleGraph(
      root: _nodeWithIndex(0),
      radius: radius,
      children: [
        for (int i = 0; i < numberOfChildren; i++) _nodeWithIndex(i + 1),
      ],
      tooltipBuilder: buildTooltip,
      circlify: true,
      backgroundColor: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            child: Icon(
              Icons.remove,
              color: ColorPicker.color3,
            ),
            onPressed: onRemove,
            backgroundColor: ColorPicker.color2,
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            child: Icon(
              Icons.add,
              color: ColorPicker.color3,
            ),
            onPressed: onAdd,
            backgroundColor: ColorPicker.color2,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: BubbleGraph(
                [
                  constructTree(
                    numberOfChildren,
                    color: ColorPicker.color5,
                  ),
                  constructTree(
                    numberOfChildren,
                    color: ColorPicker.color5,
                  ),
                  constructTree(
                    numberOfChildren,
                    color: ColorPicker.color5,
                  ),
                  constructTree(
                    numberOfChildren + 1,
                    color: ColorPicker.color5,
                  ),
                  constructTree(
                    numberOfChildren + 6,
                    color: ColorPicker.color5,
                  ),
                  CircleGraph(
                    root: _nodeWithIndex(0),
                    radius: 100,
                    children: [
                      for (int i = 0; i < numberOfChildren + 18; i++)
                        _nodeWithIndex(i + 1),
                    ],
                    circleLayout: [
                      Circle(100, 6),
                      Circle(200, -1),
                    ],
                    tooltipBuilder: buildTooltip,
                    circlify: true,
                    backgroundColor: ColorPicker.color5,
                  )
                ],
                backgroundColor: ColorPicker.color1,
                padding: EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
