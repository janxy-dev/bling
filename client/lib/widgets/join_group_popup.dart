import 'package:flutter/material.dart';

dynamic showJoinGroupPopup(BuildContext context){
  showDialog(context: context,
    barrierColor: Colors.white.withOpacity(0),
    builder: (_){
    return AlertDialog(
      elevation: 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Enter code"),
          TextField(
            autocorrect: false,
            onSubmitted: (code){
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      )
    );
  });
}