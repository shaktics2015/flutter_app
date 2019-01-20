import 'package:flutter/material.dart';

class Assets {
  // next three lines makes this class a Singleton
  static Assets _instance = Assets.internal();
  Assets.internal();
  factory Assets() => _instance; 

  final socialFacebook = "assets/social/facebook_white.png";
  final socialGoogle = "assets/social/google.png";
  ExactAssetImage logo = new ExactAssetImage("assets/logo.png");
  final imageLogoTop = Image.asset(
    "assets/logo.png",
    height: 40.0,
    fit: BoxFit.contain,
  );
}
