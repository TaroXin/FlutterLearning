import 'package:flutter/material.dart';
import './src/list.dart';
import './src/image-example.dart';
import './src/swiper-to-close.dart';
import './src/navigator-with-param.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context = context;

    return new MaterialApp(
      title: 'Welcome to Flutter',

      theme: new ThemeData(
        primaryColor: Colors.blueGrey
      ),

      routes: {
        '/list': (BuildContext context) => new RandomWords(),
        '/image': (BuildContext context) => new ImageExample(),
        '/swiper-to-close': (BuildContext context) => new SwipeToClose(),
        '/navigator-with-param': (BuildContext context) => new NavigatorWithParam(),
      },

      home: new HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('应用首页'),
      ),

      body: new Builder(builder: (BuildContext context) {
        return new Center(
          child: new Column(
            children: <Widget>[
              new RaisedButton(
                child: new Text('列表界面'),
                onPressed: () => _pushToNavigator(context, '/list'),
              ),

              new RaisedButton(
                child: new Text('图片展示'),
                onPressed: () => _pushToNavigator(context, '/image'),
              ),

              new RaisedButton(
                child: new Text('显示SnackBar'),
                onPressed: () {
                  final snackBar = new SnackBar(
                    content: new Text('蓝牙无法连接'),
                    action: new SnackBarAction(
                        label: '点击重试',
                        onPressed: () => {}
                    ),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                },
              ),

              new InkWell(
                onTap: () {
                  Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text('自定按钮弹出的内容'),
                  ));
                },
                child: new Container(
                  padding: new EdgeInsets.all(12.0),
                  decoration: new BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  child: new Text('自定义按钮'),
                ),
              ),

              new RaisedButton(
                child: new Text('List滑动关闭'),
                onPressed: () => _pushToNavigator(context, '/swiper-to-close'),
              ),

              new RaisedButton(
                child: new Text('页面间传值'),
                onPressed: () => _pushToNavigator(context, '/navigator-with-param'),
              )
            ],
          ),
        );
      })
    );
  }

  void _pushToNavigator(BuildContext context, String name) {
    Navigator.of(context).pushNamed(name);
  }
}
