import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:async';

class BannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new BannerExample(),
    );
  }
}

class BannerItem {
  String picUrl;

  BannerItem({
    this.picUrl
  });
}

class BannerExample extends StatefulWidget {
  BannerExample({
    Key key,
  });

  @override
  State<StatefulWidget> createState() {
    return new BannerState();
  }
}

class BannerState extends State<BannerExample> {
  List<BannerItem> _bannerList = new List();
  PageController _pageController;
  int _bannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    getBanner();
    setTimeoutToSwitch();
  }

  void setTimeoutToSwitch() {
    new Future.delayed(
      new Duration(seconds: 3),
      () {
        if (mounted) {
          setState(() {
            if (_bannerIndex == _bannerList.length - 1) {
              _bannerIndex = 0;
            } else {
              _bannerIndex ++;
            }

            _pageController.animateToPage(
              _bannerIndex,
              duration: new Duration(milliseconds: 600),
              curve: Curves.easeInOut,
            );

            setTimeoutToSwitch();
          });
        }
      }
    );
  }

  void getBanner() async {
    Dio dio = new Dio();
    Response response = await dio.get('http://taroxin.cn:3000/banner');
    final data = response.data;
    if (response.statusCode == 200 && data['code'] == 200) {
      final banners = data['banners'];
      setState(() {
        _bannerList = new List.generate(
            banners.length,
                (i) {
              return new BannerItem(
                  picUrl: banners[i]['picUrl']
              );
            }
        );
      });
    } else {
      print('Banner加载失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        new Container(
          height: 200.0,
          child: new PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _bannerIndex = index;
              });
            },
            children:  _bannerList.map((item) {
              return new FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: item.picUrl,
                alignment: Alignment.center,
                fit: BoxFit.fill,
              );
            }).toList(),
          ),
        ),

        new Padding(
          padding: new EdgeInsets.only(bottom: 10.0),
          child: new BannerIndicator(
              count: _bannerList.length,
              index: _bannerIndex
          ),
        )
      ],
    );
  }
}

class BannerIndicator extends StatelessWidget {
  final int count;
  final int index;

  BannerIndicator({Key key, this.count, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dots,
    );
  }

  List<Widget> get dots {
    return List.generate(
      count,
      (i) {
        return new Container(
          margin: new EdgeInsets.symmetric(horizontal: 5.0),
          width: 10.0,
          height: 10.0,
          decoration: new BoxDecoration(
            border: Border.all(color: Colors.white, width: 1.0),
            shape: BoxShape.circle,
            color: index == i ? Colors.blueGrey : Colors.transparent,
          ),
        );
      }
    );
  }
}