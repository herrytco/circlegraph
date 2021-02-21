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
  TreeNodeData rootNode = TreeNodeData(child: Text("root"));

  TreeNodeData _nodeWithIndex(int i) {
    return TreeNodeData(child: Text("child $i"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Tree(
          root: rootNode,
          children: [
            _nodeWithIndex(0),
            _nodeWithIndex(1),
            _nodeWithIndex(2),
            _nodeWithIndex(3),
            _nodeWithIndex(4),
            _nodeWithIndex(5),
            _nodeWithIndex(6),
            _nodeWithIndex(7),
            _nodeWithIndex(8),
            // _nodeWithIndex(9),
            // _nodeWithIndex(10),
            // _nodeWithIndex(11),
          ],
        ),
      ),
    );
  }
}
