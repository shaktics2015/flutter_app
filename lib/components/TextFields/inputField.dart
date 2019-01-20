import 'package:flutter/material.dart';
import '../../app/app_colors.dart';

class InputField extends StatelessWidget {
  IconData icon;
  String hintText;
  TextInputType textInputType;
  Color textFieldColor, iconColor;
  bool obscureText;
  double bottomMargin;
  TextStyle textStyle, hintStyle;
  var validateFunction;
  TextInputAction textInputAction;
  bool enabled;
  var onSaved;
  Key key;
  FocusNode focusNode;
  ValueChanged<String> onFieldSubmitted;

  //passing props in the Constructor.
  //Java like style
  InputField(
      {this.key,
      this.hintText,
      this.obscureText,
      this.textInputType,
      this.textFieldColor,
      this.icon,
      this.iconColor,
      this.bottomMargin,
      this.textStyle,
      this.validateFunction,
      this.onSaved,
      this.hintStyle,
      this.textInputAction,
      this.onFieldSubmitted,
      this.enabled: true,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return (new Container(
        margin: new EdgeInsets.only(bottom: bottomMargin),
        child: new DecoratedBox(
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(0.0)),
              color: textFieldColor),
          child: new TextFormField(
            style: textStyle,
            key: key,
            obscureText: obscureText,
            keyboardType: textInputType,
            validator: validateFunction,
            onSaved: onSaved,
            onFieldSubmitted: onFieldSubmitted,
            textInputAction: textInputAction,
            enabled: enabled,
            focusNode: focusNode,
            decoration: new InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              hintText: hintText,
              hintStyle: hintStyle,
              icon: new Icon(
                icon,
                color: iconColor,
              ),
              border: new UnderlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.white,
                    width: 1.0,
                    style: BorderStyle.none),
              ),
            ),
          ),
        )));
  }
}
