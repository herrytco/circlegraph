# Circlegraph

A Flutter plugin for creating graphs where a single node is in the center and a number of child nodes are spread evenly around this central root node.

## Features

- Provide only the data which should be displayed, no need to worry about placement;
- The widget has a **finite** size, which means it can be placed in ScrollViews, Columns, etc;
- An onClick callback can be provided to react when the user clicks on a node;
- A tooltip builder can be provided to show more information about elements in the graph when the user hovers over a node;
- Fully customize the graphs appearance by using custom widgets for nodes and providing custom colors to the widget;

## Usage

To add the package to your project, read the [install](https://pub.dev/packages/circlegraph/install) instructions on pub.dev. No additional setup-steps are required, the package works out of the box.

## Example

A simple graph, put into a circle-shaped Container could look something like this: 

![alt text](https://raw.githubusercontent.com/herrytco/circlegraph/main/.assets/sample_graph_image.png "Example of a graph created with the Circlegraph package")

To achieve a similar result, have a look at the [Example](https://pub.dev/packages/circlegraph/example) section. 