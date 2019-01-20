import 'package:flutter/material.dart'; 
import '../../data/products.dart';
import '../Orders/index.dart';
import '../../components/drawer.dart';
import '../../services/product_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product.dart';
import '../../app/app_colors.dart';

class ProductScreen extends StatefulWidget {
  final String title;
  ProductScreen({this.title});
  @override
  State<StatefulWidget> createState() {
    return new _ProductScreenState();
  }
}

class _ProductScreenState extends State<ProductScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Product> savedProducts = new List<Product>();

  @override
  void initState() {
    ProductService().fetchCart().then((res) {
      if (res != null) {
        setState(() {
          res.documents.forEach((DocumentSnapshot element) {
            element.data["documentID"]=element.documentID;
            savedProducts.add(Product.fromJson(element.data));
            print("--------------------------------");
            print("fetchCart element.data ${element.data}");
            print("--------------------------------");
          });
        });
        //  print("fetchCart savedProducts.length${savedProducts.length}");
      } else {
        print("fetchCart res $res");
      }
    }).catchError((err) {
      print("fetchCart err $err");
    });
    super.initState();
  }

  Widget _getItemTile(Product product) {
    String title = product.title;
    String subtitle = product.writer;
    String price = product.price;
    String imgUrl = product.image;
    print("savedProducts.contains(product) ${savedProducts.contains(product)}");
    return new Container(
        margin: EdgeInsets.only(top: 1.0, bottom: 1.0, right: 8.0),
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
                        if (savedProducts.contains(product)) {
                          addRemoveProducts(product, false);
                        } else {
                          addRemoveProducts(product, true);
                        }
                      });
                    },
                    child: Icon(Icons.add_shopping_cart,
                        size: 30.0,
                        color: savedProducts.contains(product)
                            ?  AppColors.lightRed
                            :  AppColors.lightGrey)),
                padding: EdgeInsets.only(top: 2.0),
              )
            ],
          ),
        ),
        decoration: new BoxDecoration(
            border: new Border(
                bottom: new BorderSide(color:  AppColors.lightGrey, width: 1.0))));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: .5,
        title: Text("${widget.title}"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: new FutureBuilder<List<Product>>(
            future: getProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, index) {
                      Product _product = snapshot.data.elementAt(index);
                      print("fetchCart  _product: ${_product.toJson()}");

                      return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, 'detail/${_product.title}');
                          },
                          child: _getItemTile(_product));
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return new Text("${snapshot.error}");
              }
              return new CircularProgressIndicator();
            },
          ),
        ),
      ),
      drawer: AppDrawer(),
      floatingActionButton: savedProducts.length > 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (ctxt) => new OrderScreen(
                          title: "Orders", savedProducts: savedProducts)),
                );
                print("Open orders page");
              },
              tooltip: 'Cart',
              child: new Stack(children: <Widget>[
                new Icon(Icons.shopping_cart),
                new Positioned(
                  top: 2.0,
                  right: 7.0,
                  child: new Text(
                    "${savedProducts.length}",
                    style: TextStyle(fontSize: 12.0, color:  AppColors.lightRed),
                  ),
                )
              ]),
              elevation: 2.0,
            )
          : Padding(padding: EdgeInsets.all(0.0)),
    );
  }

  addRemoveProducts(Product product, bool add) {
    if (add) {
      ProductService().addProduct(product.toJson());
      savedProducts.add(product);
    } else {
      savedProducts.remove(product);
      ProductService().deleteItemFromCart(product.documentID);
    }
  }
}
