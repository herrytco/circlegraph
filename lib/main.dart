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
  int numberOfChildren = 0;

  void onAdd() {
    setState(() {
      numberOfChildren += 1;
    });
  }

  TreeNodeData _nodeWithIndex(int i) {
    return TreeNodeData<int>(
      child: Text("child $i"),
      data: i,
      onNodeClick: _onNodeClick,
    );
  }

  Widget buildTooltip(TreeNodeData node, int data) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.green,
      child: Text("Hovering over node $data"),
    );
  }

  void _onNodeClick(TreeNodeData node, int data) {
    print("clicked on node $data");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onAdd,
      ),
      body: Center(
        child: CircleTree(
          root: _nodeWithIndex(0),
          children: [
            for (int i = 0; i < numberOfChildren; i++) _nodeWithIndex(i + 1),
          ],
        ),
      ),
    );
  }
}
