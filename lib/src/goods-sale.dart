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
  int goodsTotalCount = 0;

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

  void onGoodsCountChange() {
    int sum = 0;
    for (var goodsClass in _goodsList) {
      for (var goods in goodsClass.goods) {
        sum += goods.count;
      }
    }

    setState(() {
      goodsTotalCount = sum;
    });
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
              new GoodsClassState(
                _goodsList,
                onGoodsCountChange: onGoodsCountChange,
              ) :
              new GoodsLoading(),
          ),

          _goodsList.length > 0 ?
            new Container(
              height: 55.0,
              child: new Row(
                children: <Widget>[
                  new Container(
                    width: 45.0,
                    height: 40.0,
                    child: new Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: <Widget>[
                        new Center(
                          child: new Icon(
                            Icons.shopping_cart,
                            color: Colors.blue,
                          ),
                        ),

                        goodsTotalCount > 0 ?
                          new Container(
                            width: 22.0,
                            height: 22.0,
                            padding: EdgeInsets.all(2.0),
                            alignment: Alignment.center,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.redAccent
                            ),
                            child: new Text(
                              goodsTotalCount.toString(),
                              style: new TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          ) :
                          new Container()
                      ],
                    ),
                  ),

                  new Expanded(
                    child: new Container(
                    ),
                  ),

                  new Container(
                    width: 55.0,
                    height: 55.0,
                    color: Colors.orangeAccent,
                    child: new Icon(
                      Icons.crop_landscape,
                      color: Colors.white,
                    ),
                  ),

                  new Container(
                    width: 120.0,
                    height: 55.0,
                    color: Colors.blue,
                    child: new Center(
                      child: new Text(
                        '结算',
                        style: new TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ) :
            new Container()

        ],
      )
    );
  }
}

class GoodsClassState extends StatefulWidget {
  final List<GoodsClassModel> _goodsList;
  final Function onGoodsCountChange;

  GoodsClassState(this._goodsList, {Key key, this.onGoodsCountChange}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new GoodsClass(_goodsList, onGoodsCountChange: onGoodsCountChange);
  }
}

class GoodsClass extends State<GoodsClassState> {
  final List<GoodsClassModel> _goodsList;
  int _classActive = 0;
  Function onGoodsCountChange;

  GoodsClass(this._goodsList, {this.onGoodsCountChange});

  onTilePressed (index) {
    setState(() {
      _classActive = index;
    });
  }

  void onGoodsStateChange(goods, count) {
    setState(() {
      goods.count = count;
      onGoodsCountChange();
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
          child: new GoodsList(
            _goodsList,
            onGoodsStateChange: onGoodsStateChange,
          ),
        )
      ],
    );
  }
}

class GoodsList extends StatelessWidget {
  final List<GoodsClassModel> _goodsList;
  Function onGoodsStateChange;

  GoodsList(this._goodsList, {this.onGoodsStateChange});

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
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              alignment: Alignment.centerLeft,
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
            return new Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: new Container(
                height: 90.0,
                child: new Column(
                  children: <Widget>[
                    new Container(
                      color: Colors.blue,
                      height: 50.0,
                      width: 750.0,
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        goods.goodsName + "DDASDASDSAD测试测试测试测试测试测试测试测试测试测试测试",
                        style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    new Container(
                      color: Colors.white,
                      height: 40.0,
                      width: 750.0,
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            goods.price.toString(),
                            style: new TextStyle(
                              color: Colors.blue
                            ),
                          ),

                          new InputNumber(
                            goods.count,
                            add: () {
                              this.onGoodsStateChange(goods, goods.count + 1);
                            },

                            reduce: () {
                              this.onGoodsStateChange(goods, goods.count - 1);
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class InputNumber extends StatelessWidget {
  final int count;
  final Function add;
  final Function reduce;

  InputNumber(this.count, {this.add, this.reduce});

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 80.0,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          count > 0 ?
            new GestureDetector(
              child: new Container(
                  height: 20.0,
                  width: 20.0,
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: new Color(0xFFE9E9E9)
                  ),
                  child: new Text(
                    '-',
                    style: new TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  )
              ),

              onTap: () => reduce(),
            ) :
            new Container(),
          
          count > 0 ?
            new Text(
              count.toString(),
            ) :
            new Container(),

          new GestureDetector(
            child: new Container(
                height: 20.0,
                width: 20.0,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue
                ),
                child: new Text(
                  '+',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                )
            ),

            onTap: () => add(),
          ),
        ],
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
  int count = 0;

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