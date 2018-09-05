import 'package:flutter/material.dart';

class ReturnDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('请选择')
      ),

      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new RaisedButton(
            child: new Text('返回YES'),
            onPressed: () {
              Navigator.of(context).pop('YES');
            },
          ),

          new RaisedButton(
            child: new Text('返回NOPE'),
            onPressed: () {
              Navigator.of(context).pop('NOPE');
            },
          ),
        ],
      )
    );
  }
}