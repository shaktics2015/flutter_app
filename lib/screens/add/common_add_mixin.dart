import 'package:flutter/material.dart';

typedef void BoolValueChanged(bool value);

class CommonAddMixin { 

 
  final formKey = GlobalKey<FormState>();
  final focusPassword = FocusNode();
  ScrollController scrollController = ScrollController();
  
 
 
 
  scrollUp() {
    scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }
 
}
