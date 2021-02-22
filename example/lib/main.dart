import 'package:flutter/material.dart';
import 'package:circlegraph/circlegraph.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int numberOfChildren = 5;

  void onAdd() {
    setState(() {
      numberOfChildren += 1;
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

  Color get color1 => Color.fromRGBO(154, 212, 214, 1); // powder blue
  Color get color2 => Color.fromRGBO(139, 30, 63, 1); // claret (red-ish)
  Color get color3 =>
      Color.fromRGBO(240, 201, 135, 1); // gold crayola (yellow-ish)
  Color get color4 => Color.fromRGBO(71, 170, 174, 1); // verdigris
  Color get color5 => Color.fromRGBO(16, 37, 66, 1); // oxford blue

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: color3,
        ),
        onPressed: onAdd,
        backgroundColor: color2,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(100),
          decoration: BoxDecoration(
            color: color1,
            shape: BoxShape.circle,
          ),
          child: CircleTree(
            root: _nodeWithIndex(0),
            radius: 50,
            children: [
              for (int i = 0; i < numberOfChildren; i++) _nodeWithIndex(i + 1),
            ],
            tooltipBuilder: buildTooltip,
          ),
        ),
      ),
    );
  }
}
