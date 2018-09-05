import 'package:flutter/material.dart';

class SwipeToClose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('滑动关闭列表'),
      ),

      body: new SwipeList(),
    );
  }
}

class SwipeList extends StatelessWidget {
  final items = new List<String>.generate(20, (i) => 'item ${i + 1}');
  
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return new Dismissible(
          key: new Key(index.toString()),
          background: new Container(color: Colors.red),
          child: new ListTile(
            title: new Text(items[index]),
          ),
          onDismissed: (direction) {
            items.removeAt(index);

            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text('Item ${index + 1} removed!'),
            ));
          },
        );
      }
    );
  }
}