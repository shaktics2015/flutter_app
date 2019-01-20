import 'package:flutter/material.dart';
import 'screens/SignUp/index.dart';
import 'app/app_colors.dart';
import 'screens/Products/index.dart';
import 'data/products.dart';
import 'screens/Details/index.dart';
import 'welcome.dart';
import 'screens/Login/index.dart';
import 'models/product.dart';

class Routes {
  var routes = <String, WidgetBuilder>{
    "/Products": (BuildContext context) => new ProductScreen(
          title: "Products",
        ),
    "/SignUp": (BuildContext context) => new SignUpScreen(),
    "/Login": (BuildContext context) => new LoginScreen()
  };

  Routes() {
    runApp(new MaterialApp(
      title: "Flutter Assignment App",
      home: new Welcome(),
      theme:  AppColors.appTheme,
      routes: routes,
      onGenerateRoute: (settings) => generateRoute(settings),
    ));
  }
}

generateRoute(RouteSettings settings) {
  final path = settings.name.split('/');
  final title = path[1];
  Product product = products.firstWhere((it) => it.title == title);
  return MaterialPageRoute(
    settings: settings,
    builder: (context) => DetailScreen(product),
  );
}
