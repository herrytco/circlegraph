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
          style: TextStyle(color: color3),
        ),
        data: i,
        onNodeClick: _onNodeClick,
        color: color2);
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
        color: color4,
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
  /// powder blue
  ///
  Color get color1 => Color.fromRGBO(154, 212, 214, 1);

  ///
  /// claret (red-ish)
  ///
  Color get color2 => Color.fromRGBO(139, 30, 63, 1);

  ///
  /// gold crayola (yellow-ish)
  ///
  Color get color3 => Color.fromRGBO(240, 201, 135, 1);

  ///
  /// verdigris
  ///
  Color get color4 => Color.fromRGBO(71, 170, 174, 1);

  ///
  /// oxford blue
  ///
  Color get color5 => Color.fromRGBO(16, 37, 66, 1);

  CircleTree constructTree(int numberOfChildren, {color = Colors.blue}) {
    return CircleTree(
      root: _nodeWithIndex(0),
      radius: 50,
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
              color: color3,
            ),
            onPressed: onRemove,
            backgroundColor: color2,
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            child: Icon(
              Icons.add,
              color: color3,
            ),
            onPressed: onAdd,
            backgroundColor: color2,
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: BubbleGraph(
              [
                constructTree(numberOfChildren+1),
                constructTree(numberOfChildren),
                constructTree(numberOfChildren, color: Colors.amber),
                constructTree(numberOfChildren+3, color: Colors.pink),
                constructTree(numberOfChildren+6, color: Colors.lime),
                constructTree(numberOfChildren, color: Colors.indigo),
                constructTree(numberOfChildren, color: Colors.orange),
                constructTree(numberOfChildren, color: Colors.teal),
                constructTree(numberOfChildren, color: Colors.tealAccent),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text("$numberOfChildren children per circle"),
          ),
        ],
      ),
    );
  }
}
