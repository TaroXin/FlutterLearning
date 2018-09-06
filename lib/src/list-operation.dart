import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:async';

class ListOperationState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ListOperation();
  }
}
class ListOperation extends State<ListOperationState> {
  List<WordPair> _wordList;

  @override
  void initState() {
    super.initState();
    _wordList = new List();
    _wordList.addAll(generateWordPairs().take(20));
  }

  Future onRefresh() {
    return Future.delayed(
      new Duration(seconds: 3),

      () {
        setState(() {
          _wordList.clear();
          _wordList.addAll(generateWordPairs().take(20));
        });
      }
    );
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (notification.metrics.extentAfter == 0.0) {
        // 到最底部了
        setState(() {
          _wordList.addAll(generateWordPairs().take(20));
        });
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('List操作'),
      ),
      
      body: new NotificationListener(
        onNotification: onNotification,
        child: new RefreshIndicator(
            color: Colors.blue,
            child: new ListView.builder(
              itemCount: _wordList.length,
              itemBuilder: (context, index) {
                return new Column(
                  children: <Widget>[
                    new ListTile(
                        title: new Text(_wordList[index].asPascalCase)
                    ),

                    new Divider(height: 5.0)
                  ],
                );
              },
            ),
            onRefresh: onRefresh
        ),
      )
    );
  }
}