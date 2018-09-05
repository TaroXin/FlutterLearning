import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

void main () => runApp(new ImageExample());

class ImageExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('图片展示界面'),
      ),
      
      body: new SingleChildScrollView(
        child: new Center(
          child: new Column(
            children: <Widget>[
              new RaisedButton(
                child: new Text('返回'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new Text('网络展示图片'),
              new Image.network(
                'http://p6ngidppe.bkt.clouddn.com/cloud.jpg',
                height: 300.0,
              ),

              new Text('网络展示GIF图片'),
              new FadeInImage.memoryNetwork(
                image: 'http://p6ngidppe.bkt.clouddn.com/demo_ipod.gif',
                height: 300.0,
                placeholder: kTransparentImage,
              ),

              new Text('本地显示图片'),
              new Image(
                image: new AssetImage(
                    'assets/test.png'
                ),
              )

            ],
          ),
        )
      ),
    );
  }
}