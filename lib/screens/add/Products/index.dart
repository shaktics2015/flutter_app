import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common_add_mixin.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/TextFields/inputField.dart';
import '../../../components/Buttons/textButton.dart';
import '../../../components/Buttons/roundedButton.dart'; 
import '../../../app/app_colors.dart';


class AddProductsScreen extends StatefulWidget {
  const AddProductsScreen({Key key}) : super(key: key);

  @override
  AddProductsScreenState createState() => new AddProductsScreenState();
}

class AddProductsScreenState extends State<AddProductsScreen> with CommonAddMixin{   
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  BuildContext context;
  final focusPassword = FocusNode();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  bool autovalidate = false; 

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
      Navigator.pushNamed(context, "/Products");
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final Size screenSize = MediaQuery.of(context).size; 
  //  Validations validations = new Validations();
    return new Scaffold(
        key: _scaffoldKey,
        body: new SingleChildScrollView(
            controller: scrollController,
            child: new Container(
              padding: new EdgeInsets.only(top: 6.0, right: 16.0, left: 16.0),
           //   decoration: new BoxDecoration(image: backgroundImage),
              child: new Column(
                children: <Widget>[  
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
                                  hintText: "Title",
                                  obscureText: false,
                                  textInputType: TextInputType.text,
                                  textStyle:  AppColors.textStyle,
                                  textFieldColor:  AppColors.textFieldColor,
                                  icon: Icons.lock_open,
                                  iconColor:  AppColors.white,
                                  bottomMargin: 30.0,
                                  // validateFunction:
                                  //     validations.validatePassword,
                                  onSaved: (String val) {
                                   }),
                              new RoundedButton(
                                buttonName: "Save",
                                onTap: _handleSubmitted,
                                width: screenSize.width,
                                height: 50.0,
                                bottomMargin: 10.0,
                                borderWidth: 0.0,
                                buttonColor:  AppColors.primaryColor,
                              ),
                            ],
                          ),
                        ),
                        new Container(child:  new TextButton(
                                buttonName: "Discard",
                                onPressed: () => onPressed("/Products"),
                                buttonTextStyle:  AppColors.buttonTextStyle),),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

 
}
