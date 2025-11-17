import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ContextExtenssion on BuildContext{
  void showSnackBar({required String message, bool error = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message,),
        backgroundColor: error ?  Colors.red.shade800 : Color(0xFF2d2b4f),
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(seconds: 2),
      ),
    );

  }
}