import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class GoodsSale extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GoodsSaleComponent();
  }
}

class GoodsSaleComponent extends State<GoodsSale> {
  List<GoodsClassModel> _goodsList = new List();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    Dio dio = new Dio();
    Map<String, dynamic> headers = new Map();
    headers['authorization'] = 'Token djREH7rxL0WlKQHvO5BZrJkE';

    Response res = await dio.get(
      'http://neidebug.youcaihua.net:8081/nei/mock/yunyouminipos/api/v1/Goods/GoodsList?IsExchange=false',
      options: new Options(
        headers: headers
      )
    );

    final responseStatus = res.data['ResponseStatus'];
    final data = res.data['Data'];
    if (res.statusCode == 200 && responseStatus['ErrorCode'] == '0') {
      setState(() {
        _goodsList = new List.generate(
            data['Data'].length,
                (index) {
              return new GoodsClassModel.fromJson(data['Data'][index]);
            }
        );
      });
    } else {
      print(responseStatus['Message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('商品售卖'),
      ),

      body: new Column(
        children: <Widget>[
          new Expanded(
            child: _goodsList.length > 0 ?
              new GoodsClassState(_goodsList) :
              new GoodsLoading(),
          ),

          _goodsList.length > 0 ?
            new Container(
              color: Colors.blue,
              height: 55.0,
            ) :
            new Container()

        ],
      )
    );
  }
}

class GoodsClassState extends StatefulWidget {
  final List<GoodsClassModel> _goodsList;

  GoodsClassState(this._goodsList, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new GoodsClass(_goodsList);
  }
}

class GoodsClass extends State<GoodsClassState> {
  final List<GoodsClassModel> _goodsList;
  int _classActive = 0;

  GoodsClass(this._goodsList);

  onTilePressed (index) {
    setState(() {
      _classActive = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Container(
          width: 100.0,
          child: new ListView.builder(
            itemCount: _goodsList.length,
            itemBuilder: (context, index) {
              GoodsClassModel goodsClass = _goodsList[index];

              return new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                      goodsClass.name,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: _classActive == index ? new Color(0xFF333333) : new Color(0xFFB0B0B0)
                      ),
                    ),
                    onTap: () => onTilePressed(index),
                  ),

                  new Divider(height: 5.0),
                ],
              );
            },
          ),
        ),

        new Expanded(
          child: new GoodsList(_goodsList),
        )
      ],
    );
  }
}

class GoodsList extends StatelessWidget {
  final List<GoodsClassModel> _goodsList;

  GoodsList(this._goodsList);

  List get formatGoodsList {
    List list = new List();
    for (var goodsClass in _goodsList) {
      list.add(goodsClass);
      for (var value in goodsClass.goods) {
        list.add(value);
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: new Color(0xFFE9E9E9),
      child: new ListView.builder(
        itemCount: formatGoodsList.length,
        itemBuilder: (context, index) {
          if (formatGoodsList[index] is GoodsClassModel) {
            GoodsClassModel goodsClass = formatGoodsList[index];
            return new Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              color: new Color(0xFFC0C0C0),
              height: 25.0,
              child: new Text(
                goodsClass.name,
                style: new TextStyle(
                  color: new Color(0xFF333333)
                ),
              ),
            );
          } else {
            GoodsModel goods = formatGoodsList[index];
            return new ListTile(
              title: new Text(goods.goodsName),
            );
          }
        },
      ),
    );
  }
}

class GoodsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new SpinKitThreeBounce(
            color: new Color(0xFFD0D0D0),
            size: 20.0,
          ),
          new Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: new Text(
              '正在加载',
              style: new TextStyle(
                color: new Color(0xFFD0D0D0),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GoodsClassModel {
  String name;
  List<GoodsModel> goods;

  GoodsClassModel({
    this.name,
    this.goods
  });

  GoodsClassModel.fromJson(Map<String, dynamic> json)
    : name = json['Name'],
      goods = new List.generate(
        json['Goods'].length,
        (index) {
          return new GoodsModel.fromJson(json['Goods'][index]);
        }
      );
}

class GoodsModel {
  String goodsId;
  String goodsName;
  double price;
  bool isCurrency;
  String goodsCode;

  GoodsModel({
    this.goodsId,
    this.goodsName,
    this.price,
    this.isCurrency,
    this.goodsCode
  });

  GoodsModel.fromJson(Map<String, dynamic> json)
    : goodsId = json['GoodsID'],
      goodsName = json['GoodsName'],
      price = double.parse(json['Price'].toString()),
      isCurrency = json['IsCurrency'],
      goodsCode = json['GoodsCode'];
}