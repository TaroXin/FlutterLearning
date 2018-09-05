import 'package:flutter/material.dart';

class Todo {
  final String title;
  final String description;

  Todo({this.title, this.description});
}

class NavigatorWithParam extends StatelessWidget {
  final items = new List<Todo>.generate(20, (i) => new Todo(
    title: 'Title ${i + 1}',
    description: 'This is description item ${i + 1}'
  ));

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('页面间的传值'),
      ),

      body: new ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return new ListTile(
            title: new Text(items[index].title),

            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new DetailScreen(todo: items[index])
              ));
            },
          );
        },
      )
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Todo todo;

  DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(todo.title)
      ),

      body: new Center(
        child: new Column(
          children: <Widget>[
            new Text(
              todo.description,
              style: new TextStyle(
                fontSize: 32.0,
                color: Colors.blueAccent
              ),
            ),
          ],
        ),
      ),
    );
  }
}