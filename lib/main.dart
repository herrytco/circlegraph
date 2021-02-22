import 'package:circlegraph/tree.dart';
import 'package:circlegraph/tree_node_data.dart';
import 'package:flutter/material.dart';

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

  void _onNodeClick(TreeNodeData node, int data) {
    print("clicked on node $data");
  }

  _hexStringToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  String _color1String = "9ad4d6"; // powder blue
  String _color2String = "8b1e3f"; // claret (red-ish)
  String _color3String = "f0c987"; // gold crayola (yellow-ish)
  String _color4String = "47AAAE"; // verdigris
  String _color5String = "102542"; // oxford blue

  Color get color1 => _hexStringToColor(_color1String);
  Color get color2 => _hexStringToColor(_color2String);
  Color get color3 => _hexStringToColor(_color3String);
  Color get color4 => _hexStringToColor(_color4String);
  Color get color5 => _hexStringToColor(_color5String);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onAdd,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(160),
          decoration: BoxDecoration(
            color: color1,
            shape: BoxShape.circle,
          ),
          child: CircleTree(
            root: _nodeWithIndex(0),
            children: [
              for (int i = 0; i < numberOfChildren; i++) _nodeWithIndex(i + 1),
            ],
            tooltipBuilder: buildTooltip,
            backgroundColor: color1,
            edgeColor: color2,
          ),
        ),
      ),
    );
  }
}
