import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../enums/action.dart';
import '../app/app_colors.dart';
import '../app/assets.dart';
import '../screens/Profile/index.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/Orders/index.dart';
import '../models/product.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AppDrawer extends StatelessWidget {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  FacebookLogin fbLogin = new FacebookLogin();

  @override
  Widget build(BuildContext context) {
    Color color;

    return Drawer(
        child: ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 4,
      itemBuilder: (context, index) {
        color = AppColors.transparent;
        if (index == 0) {
          return _widgetRow(Action.none, context);
        } else if (index == 1) {
          color = AppColors.lightOrange;
          return _widgetRow(Action.account, context, label: "Account");
          // } else if (index == 2) {
          //   color =  AppColors.lightOrange;
          //   return _widgetRow(Action.addProducts, context, label: "Add Products");
        } else if (index == 2) {
          color = AppColors.lightOrange;
          return _widgetRow(Action.orders, context, label: "Orders");
        } else if (index == 3) {
          color = AppColors.lightOrange;
          return _widgetRow(Action.logout, context, label: "Logout");
        }
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 1.0,
          color: color,
        );
      },
    ));
  }

  Widget _widgetRow(Action action, BuildContext context, {String label}) {
    if (action == Action.none) {
      return DrawerHeader(
        child: Center(child: Assets().imageLogoTop),
        decoration: BoxDecoration(
          color: AppColors.blueLightTeal,
        ),
      );
    } else {
      return ListTile(
        title: Text(label),
        onTap: () {
          if (action == Action.logout) {
            UserService().logout('email', preferences: _prefs);
            UserService()
                .restorePreferences('login_type', preferences: _prefs)
                .then((loginType) {
              print(
                  'FirebaseAuth.instance.signOut.then success loginType: $loginType');
              if (loginType == "DIRECT" && loginType == "GOOGLE") {
                FirebaseAuth.instance.signOut().then((res) {
                  print('FirebaseAuth.instance.signOut.then success');
                }).catchError((err) {
                  print('FirebaseAuth.instance.signOut.catchError : $err');
                });
              }else{
                fbLogin.logOut();
              }
                          UserService().logout('login_type', preferences: _prefs);

                                Navigator.of(context).pushReplacementNamed('/Login');

            }).catchError((err) {});

            // _confirm(context);
          } else if (action == Action.account) {
            Navigator.pop(context);
            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (ctxt) => new ProfileScreen(profile: new User()),
                ));
            // } else if (action == Action.addProducts) {
            //   Navigator.pop(context);
            //   Navigator.push(
            //     context,
            //     new MaterialPageRoute(builder: (ctxt) => new AddProductsScreen()),
            //   );
          } else if (action == Action.orders) {
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (ctxt) => new OrderScreen(
                        title: "Orders",
                        savedProducts: new List<Product>(),
                      )),
            );
          }
        },
      );
    }
  }
}
