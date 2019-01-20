import 'package:flutter/material.dart';
import '../../services/product_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product.dart';
import '../../app/app_colors.dart';

class OrderScreen extends StatefulWidget {
  final String title;

  List<Product> savedProducts;
  OrderScreen({this.title, this.savedProducts});
  @override
  State<StatefulWidget> createState() {
    return new _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  QuerySnapshot result;

  @override
  void initState() {
    super.initState();
    if (widget.savedProducts.length < 1) {
      ProductService().fetchCart().then((res) {
        if (res != null) {
          print("fetchCart res.documents ${res.documents}");
          setState(() {
            res.documents.forEach((DocumentSnapshot element) {
              element.data["documentID"] = element.documentID;
              widget.savedProducts.add(Product.fromJson(element.data));
            });
          });

          print("fetchCart widget.savedProducts${widget.savedProducts}");
        } else {
          print("fetchCart res $res");
        }
      }).catchError((err) {
        print("fetchCart err $err");
      });
    }
  }

  Widget _getItemTile(Product product) {
    String title = product.title;
    String subtitle = product.writer;
    String price = product.price;
    String imgUrl = product.image;

    return new Container(
        margin: EdgeInsets.only(top: 1.0, bottom: 1.0, right: 8.0),
        child: Dismissible(
          // Show a red background as the item is swiped away
          background: Container(color: AppColors.red),
          key: Key("${product.id}"),
          onDismissed: (direction) {
            setState(() {
              widget.savedProducts.remove(product);
              ProductService().deleteItemFromCart(product.documentID);
            });
          },
          child: new ListTile(
            contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
            leading: new Image(
              image: AssetImage(imgUrl),
              height: 60.0,
              width: 60.0,
              fit: BoxFit.fitWidth,
            ),
            title: new Text(title),
            subtitle: new Text(subtitle),
            trailing: Column(
              children: <Widget>[
                Text(
                  price,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                Container(
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.savedProducts.remove(product);
                          ProductService()
                              .deleteItemFromCart(product.documentID);
                        });
                      },
                      child: Icon(Icons.add_shopping_cart,
                          size: 30.0, color: AppColors.lightRed)),
                  padding: EdgeInsets.only(top: 2.0),
                )
              ],
            ),
          ),
        ),
        decoration: new BoxDecoration(
            border: new Border(
                bottom:
                    new BorderSide(color: AppColors.lightGrey, width: 1.0))));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            elevation: .5,
            title: Text("${widget.title}"),
            centerTitle: true,
            leading: new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Icon(Icons.arrow_back, color: AppColors.white),
            )),
        body: FutureBuilder<dynamic>(
            future: ProductService().fetchCart(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: const CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    print(
                        ' fetchCart success widget.savedProducts.length: ${widget.savedProducts.length}');
                    if (snapshot.hasData && snapshot.data != null) {
                      return Center(
                        child: Container(
                          child: ListView.builder(
                            itemCount: widget.savedProducts.length,
                            itemBuilder: (BuildContext context, index) {
                              Product _product =
                                  widget.savedProducts.elementAt(index);
                              print('fetchCart snapshot _product: $_product');
                              return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, 'detail/${_product.title}');
                                  },
                                  child: _getItemTile(_product));
                            },
                          ),
                        ),
                      );
                    } else {
                      return Text("Loading");
                    }
                  }
              }
            }));
  }
}
