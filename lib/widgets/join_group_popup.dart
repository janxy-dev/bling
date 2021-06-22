import 'package:flutter/material.dart';

dynamic createJoinGroupPopup(BuildContext context){
  showDialog(context: context, builder: (_){
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Enter code"),
          TextField(
            autocorrect: false,
          )
        ],
      )
    );
  });
}