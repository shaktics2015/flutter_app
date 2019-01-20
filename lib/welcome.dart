import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/Login/index.dart';
import 'screens/Products/index.dart';
import 'services/user_service.dart';

class Welcome extends StatefulWidget {
  Welcome({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<bool>(
          future: UserService().isLoggedIn(preferences: _prefs),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  print('snapshot data: ${snapshot.data}');
                  print('snapshot hasData: ${snapshot.hasData}');
                  if (snapshot.hasData &&
                      (snapshot.data == true && snapshot.data != null)) {
                    return ProductScreen(
                        title: 'Products'); // , addedItems: Map<String, bool>()
                  } else {
                    return LoginScreen();
                  }
                }
            }
          }),
    );
  }
}
