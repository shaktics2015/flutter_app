import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'style.dart';
import '../../components/TextFields/inputField.dart';
import '../../components/Buttons/textButton.dart';
import '../../components/Buttons/roundedButton.dart';
import '../../services/validations.dart';
import 'common_login_mixin.dart';
import '../../enums/action.dart';
import '../../app/assets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> with CommonLoginMixin {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  BuildContext context;
  final focusPassword = FocusNode();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  bool autovalidate = false;
  String _email;
  String _password;
  Validations validations = new Validations();

  onPressed(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true;
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((FirebaseUser user) {
        showInSnackBar('signedInUser.then: $user');
        print('signedInUser.then: $user');
        UserService().saveToSharedPreferences('email', user.email, "STRING",
            preferences: _prefs);
        UserService().saveToSharedPreferences('login_type', 'DIRECT', "STRING",
            preferences: _prefs);

        Navigator.of(context).pushReplacementNamed('/Products');
      }).catchError((err) {
        showInSnackBar('signedInUser.catchError : $err');
        print('signedInUser.catchError : $err');
      });
      //Navigator.pushNamed(context, "/Products");
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final Size screenSize = MediaQuery.of(context).size;
    Validations validations = new Validations();
    return new Scaffold(
        key: _scaffoldKey,
        body: new SingleChildScrollView(
            controller: scrollController,
            child: new Container(
              padding: new EdgeInsets.only(top: 6.0, right: 16.0, left: 16.0),
              decoration: new BoxDecoration(image: backgroundImage),
              child: new Column(
                children: <Widget>[
                  new Container(
                    height: screenSize.height / 4,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Center(
                            child: new Image(
                          image: Assets().logo,
                          width: (screenSize.width < 500)
                              ? 120.0
                              : (screenSize.width / 4) + 12.0,
                          height: screenSize.height / 6 + 20,
                        ))
                      ],
                    ),
                  ),
                  socialButton("Facebook", Action.facebook, context,
                      (isSubmitting) {
                    if (mounted) {
                      setState(() {
                        // disable btn
                      });
                    }
                  }),
                  SizedBox(height: 10.0),
                  socialButton("Google", Action.google, context,
                      (isSubmitting) {
                    if (mounted) {
                      setState(() {
                        // disable btn
                      });
                    }
                  }),
                  Padding(
                    padding: EdgeInsets.all(23.0),
                  ),
                  new Container(
                    height: screenSize.height / 2,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Form(
                          key: formKey,
                          autovalidate: autovalidate,
                          child: new Column(
                            children: <Widget>[
                              new InputField(
                                  hintText: "Email",
                                  obscureText: false,
                                  textInputType: TextInputType.emailAddress,
                                  textStyle: AppColors.textStyle,
                                  textFieldColor: AppColors.textFieldColor,
                                  textInputAction: TextInputAction.next,
                                  icon: Icons.mail_outline,
                                  iconColor: AppColors.white,
                                  enabled: true,
                                  bottomMargin: 20.0,
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
                                  bottomMargin: 30.0,
                                  validateFunction:
                                      validations.validatePassword,
                                  onSaved: (String password) {
                                    _password = password;
                                  }),
                              new RoundedButton(
                                buttonName: "Get Started",
                                onTap: _handleSubmitted,
                                width: screenSize.width,
                                height: 50.0,
                                bottomMargin: 10.0,
                                borderWidth: 0.0,
                                buttonColor: AppColors.primaryColor,
                              ),
                            ],
                          ),
                        ),
                        new Container(
                          child: new TextButton(
                              buttonName: "Create Account",
                              onPressed: () => onPressed("/SignUp"),
                              buttonTextStyle: AppColors.buttonTextStyle),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
