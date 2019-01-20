import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserService {
  static UserService _instance = UserService.internal();
  UserService.internal();
  factory UserService() => _instance;

  storeNewUser(FirebaseUser user, BuildContext context) {
    final data = {'email': user.email, 'uid': user.uid};
    print("storeNewUser input data $data");

    Firestore.instance.collection('/users').add(data).then((res) {
      print("storeNewUser res ${res.documentID}");
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/Products');
    }).catchError((err) {
      print("storeNewUser err $err");
    });
  }

  saveToSharedPreferences(String key, var data, String type,
      {Future<SharedPreferences> preferences}) async {
    print("saveToSharedPreferences key: $key, data: $data and type: $type");
    SharedPreferences prefs = await preferences;
    prefs.remove(key);
    switch (type) {
      case "INT":
        prefs.setInt(key, data);
        break;
      case "STRING":
        prefs.setString(key, data);
        break;
      case "BOOL":
        prefs.setBool(key, data);
        break;
    }
  }

  logout(String key, {Future<SharedPreferences> preferences}) async {
    SharedPreferences prefs = await preferences;
    print("restorePreferences key: $key");
    prefs.remove(key);
  }

  Future<String> restorePreferences(String key,
      {Future<SharedPreferences> preferences}) async {
    print("restorePreferences key: $key");
    SharedPreferences prefs = await preferences;
    return prefs.getString(key);
  }

  Future<bool> isLoggedIn({Future<SharedPreferences> preferences}) async {
    final logged = await restorePreferences('email', preferences: preferences);
    return (logged == "" || logged == null || logged == "null") ? false : true;
  }

   Future<void> addUser(User user) async {  
      Firestore.instance
          .collection('user-${user.email??user.providerId }')
          .add(user.toJson())
          .then((res) {
        print("addProduct res ${res.documentID}");
      }).catchError((err) {
        print("addProduct err $err");
      }); 
  }


   Future<QuerySnapshot> fetchUser() async {  
      final logged = await restorePreferences('email',
          preferences: SharedPreferences.getInstance());
          print("fetchUser logged: $logged");
      return await Firestore.instance
          .collection('user-$logged')
        .getDocuments();
  }
}
