import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_service.dart';

class ProductService {
  static ProductService _instance = ProductService.internal();
  ProductService.internal();
  factory ProductService() => _instance;

  bool _isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addProduct(product) async {
    if (_isLoggedIn()) {
      final logged = await UserService().restorePreferences('email',
          preferences: SharedPreferences.getInstance());
      Firestore.instance
          .collection('products-$logged')
          .add(product)
          .then((res) {
        print("addProduct res ${res.documentID}");
      }).catchError((err) {
        print("addProduct err $err");
      });
    } else {
      print("Not logged in");
    }
  }

  Future<dynamic> fetchCart() async {
    final logged = await UserService().restorePreferences('email',
        preferences: SharedPreferences.getInstance());
    return await Firestore.instance
        .collection('products-$logged')
        .getDocuments();
  }

  Future<dynamic> updateCart(selected, newData) async {
    final logged = await UserService().restorePreferences('email',
        preferences: SharedPreferences.getInstance());

    return await Firestore.instance
        .collection('products-$logged')
        .document(selected)
        .updateData(newData)
        .then((res) {
      print("updateCart success");
    }).catchError((err) {
      print("updateCart err $err");
    });
  }

  Future<dynamic> deleteItemFromCart(id) async {
    final logged = await UserService().restorePreferences('email',
        preferences: SharedPreferences.getInstance());

    return await Firestore.instance
        .collection('products-$logged')
        .document(id)
        .delete()
        .then((res) {
      print("deleteItemFromCart success");
    }).catchError((err) {
      print("deleteItemFromCart err $err");
    });
  }
}
