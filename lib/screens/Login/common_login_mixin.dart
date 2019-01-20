import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/app_colors.dart';
import '../../app/assets.dart';
import '../../enums/action.dart';
import '../../models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

typedef void BoolValueChanged(bool value);

class CommonLoginMixin {
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  //final mainReference = FirebaseDatabase.instance.reference();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Google sign-in
  GoogleSignIn googleAuth = new GoogleSignIn();
  // Facebook Sign-in
  FacebookLogin fbLogin = new FacebookLogin();

  final formKey = GlobalKey<FormState>();
  final focusPassword = FocusNode();
  ScrollController scrollController = ScrollController();

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.+]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  RaisedButton socialButton(String text, Action action, BuildContext context,
      BoolValueChanged valueChanged) {
    var color = AppColors.facebookBlue;
    var textColor = AppColors.white;
    var image = Assets().socialFacebook;
    if (action == Action.google) {
      color = AppColors.white;
      textColor = AppColors.lightBlack;
      image = Assets().socialGoogle;
    }

    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: color,
      textColor: textColor,
      //elevation: 1.0,
      child: Container(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Image.asset(
                    image,
                    height: 30.0,
                    width: 30.0,
                    fit: BoxFit.contain,
                  )),
              Expanded(
                  child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  textBaseline: TextBaseline.alphabetic,
                ),
              )),
            ],
          )),
      onPressed: () async {
        valueChanged(true);
        if (action == Action.facebook) {
          await _doLoginFacebook(context);
          // valueChanged(boolValue);
        } else {
          _doLoginGoogle(context);
          // align for google
        }
      },
    );
  }

  _doLoginGoogle(BuildContext context) async {
    googleAuth.signIn().then((result) {
      result.authentication.then((googleKey) {
        print('_doLoginGoogle.googleKey: $googleKey');
        FirebaseAuth.instance
            .signInWithGoogle(
                accessToken: googleKey.accessToken, idToken: googleKey.idToken)
            .then((FirebaseUser user) {
          UserInfo userInfo = user.providerData[0];
          User userObj = User(
              email: userInfo.email,
              providerId: userInfo.providerId,
              thumbnailUrl: userInfo.photoUrl,
              uid: userInfo.uid,
              username: userInfo.displayName,
              mobile: userInfo.phoneNumber);
          UserService().saveToSharedPreferences(
              userInfo.email != null ? 'email' : 'phone_number',
              userInfo.email != null ? userInfo.email : userInfo.phoneNumber,
              "STRING",
              preferences: _prefs);
          UserService().saveToSharedPreferences(
              'login_type', 'GOOGLE', "STRING",
              preferences: _prefs);

          UserService().addUser(userObj);
          Navigator.of(context).pushReplacementNamed('/Products');
        }).catchError((err) {
          print('FirebaseAuth.instance.signInWithGoogle.catchError : $err');
        });
        ;
      }).catchError((err) {
        print('_doLoginGoogle.googleKey.catchError : $err');
      });
      print('_doLoginGoogle.result: $result');
    }).catchError((err) {
      print('_doLoginGoogle.catchError : $err');
    });
  }

  Future<Null> _doLoginFacebookUnused(context) async {
    fbLogin
        .logInWithReadPermissions(["email", "public_profile"]).then((result) {
      print('_doLoginFacebook.result: $result');
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          print(
              'Loggedin FAcebook result.accessToken.token: ${result.accessToken.token}');
          FirebaseAuth.instance
              .signInWithFacebook(accessToken: result.accessToken.token)
              .then((user) {
            print('_doLoginFacebook.signInWithFacebook.user : $user');
            UserService().saveToSharedPreferences(
                user.email != null ? 'email' : 'phone_number',
                user.email != null ? user.email : user.phoneNumber,
                "STRING",
                preferences: _prefs);

            Navigator.of(context).pushReplacementNamed('/Products');
          }).catchError((err) {
            print('_doLoginFacebook.signInWithFacebook.catchError : $err');
          });
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('Login cancelled by the user.');
          break;
        case FacebookLoginStatus.error:
          print('Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.errorMessage}');
          break;
      }
    }).catchError((err) {
      print('_doLoginFacebook.catchError : $err');
    });
  }

  Future<Null> _doLoginFacebook(context) async {
    facebookSignIn.loginBehavior = FacebookLoginBehavior.webViewOnly;

    final FacebookLoginResult result =
        await facebookSignIn.logInWithReadPermissions(['email']);
    print("result.status ${result.status}");
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print('''
Logged in!
Token: ${accessToken.token}
User id: ${accessToken.userId}
Expires: ${accessToken.expires}
Permissions: ${accessToken.permissions}
Declined permissions: ${accessToken.declinedPermissions}
''');
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture.width(720).height(720),first_name,birthday,hometown,last_name,email&access_token=${result.accessToken.token}');
        var user = json.decode(graphResponse.body);
        print("FB PROFILE --> " + user.toString());

        // var contactResponse = await http.get(
        //     'https://graph.facebook.com/me?fields=address,mobile_phone&access_token=${result.accessToken.token}');
        // var contactResponseObj = json.decode(contactResponse.body);
        // print("FB PROFILE contactResponseObj--> $contactResponseObj");
        UserService().saveToSharedPreferences('email',
            user["email"] != null ? user["email"] : user["id"], "STRING",
            preferences: _prefs);
        UserService().saveToSharedPreferences(
            'login_type', 'FACEBOOK', "STRING",
            preferences: _prefs);
        User userObj = User(
            email: user["email"],
            providerId: user["id"],
            thumbnailUrl: user["picture"]["data"]["url"] ?? "",
            uid: user["id"],
            username: user["first_name"] + user["last_name"],
            mobile: user["phoneNumber"] ?? "");
        UserService().addUser(userObj);

        Navigator.of(context).pushReplacementNamed('/Products');
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  scrollUp() {
    scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<Null> fbLogOut() async {
    await facebookSignIn.logOut();
  }
}
