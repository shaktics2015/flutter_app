import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'style.dart';
import '../../components/TextFields/inputField.dart';
import '../../components/Buttons/roundedButton.dart';
import '../../services/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app/app_colors.dart';
import '../../services/user_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  SignUpScreenState createState() => new SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _autovalidate = false;
  String _email;
  String _password;
  Validations _validations = new Validations();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true;
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      )
          .then((FirebaseUser user) {
        UserService().storeNewUser(user, context);
        showInSnackBar('signedInUser.then: $user');
        print('signedInUser.then: $user');
      }).catchError((err) {
        showInSnackBar('signedInUser.catchError : $err');
        print('signedInUser.catchError : $err');
      });
      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
        key: _scaffoldKey,
        body: new SingleChildScrollView(
          child: new Container(
            padding: new EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
            height: screenSize.height,
            decoration: new BoxDecoration(image: backgroundImage),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                    height: screenSize.height / 2 + 20,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "CREATE ACCOUNT",
                          textAlign: TextAlign.center,
                          style: headingStyle,
                        )
                      ],
                    )),
                new Column(
                  children: <Widget>[
                    new Form(
                        key: _formKey,
                        autovalidate: _autovalidate,
                        child: new Column(
                          children: <Widget>[
                            new InputField(
                                hintText: "Email",
                                obscureText: false,
                                textInputType: TextInputType.emailAddress,
                                textStyle: AppColors.textStyle,
                                textFieldColor: AppColors.textFieldColor,
                                icon: Icons.mail_outline,
                                iconColor: AppColors.white,
                                bottomMargin: 20.0,
                                validateFunction: _validations.validateEmail,
                                onSaved: (String email) {
                                  _email = email;
                                }),
                            new InputField(
                                hintText: "Password",
                                obscureText: true,
                                textInputType: TextInputType.text,
                                textStyle: AppColors.textStyle,
                                textFieldColor: AppColors.textFieldColor,
                                icon: Icons.lock_open,
                                iconColor: AppColors.white,
                                bottomMargin: 40.0,
                                validateFunction: _validations.validatePassword,
                                onSaved: (String password) {
                                  _password = password;
                                }),
                            new RoundedButton(
                                buttonName: "Continue",
                                onTap: _handleSubmitted,
                                width: screenSize.width,
                                height: 50.0,
                                bottomMargin: 10.0,
                                borderWidth: 1.0)
                          ],
                        )),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
