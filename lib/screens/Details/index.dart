import '../../components/rating_bar.dart';
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../app/app_colors.dart';

class DetailScreen extends StatelessWidget {
  final Product product;

  DetailScreen(this.product);

  @override
  Widget build(BuildContext context) {
    //app bar
    final appBar = AppBar(
      elevation: .5,
      centerTitle: true,
      title: Text('Product Details'),
    );

    ///DetailScreen of product image and it's pages
    final topLeft = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Hero(
            tag: product.title,
            child: Material(
              elevation: 15.0,
              shadowColor: AppColors.lightOrange,
              child: Image(
                image: AssetImage(product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        text('${product.pages} pages', color: AppColors.lightBlack, size: 12)
      ],
    );

    ///DetailScreen top right
    final topRight = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text(product.title,
            size: 16, isBold: true, padding: EdgeInsets.only(top: 16.0)),
        text(
          'by ${product.writer}',
          color: AppColors.lightBlack,
          size: 12,
          padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
        ),
        Row(
          children: <Widget>[
            text(
              product.price,
              isBold: true,
              padding: EdgeInsets.only(right: 8.0),
            ),
            RatingBar(rating: product.rating)
          ],
        ),
        SizedBox(height: 32.0),
      ],
    );

    final topContent = Container(
      color: AppColors.lightOrange,
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(flex: 2, child: topLeft),
          Flexible(flex: 3, child: topRight),
        ],
      ),
    );

    ///scrolling text description
    final bottomContent = Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          product.description,
          style: TextStyle(fontSize: 13.0, height: 1.5),
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }

  ///create text widget
  text(String data,
          {Color color = Colors.black87,
          num size = 14,
          EdgeInsetsGeometry padding = EdgeInsets.zero,
          bool isBold = false}) =>
      Padding(
        padding: padding,
        child: Text(
          data,
          style: TextStyle(
              color: color,
              fontSize: size.toDouble(),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      );
}
