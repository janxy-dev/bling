import 'package:flutter/material.dart';

dynamic createAddGroupPopup(BuildContext context){
  showDialog(context: context, builder: (_){
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
              onPressed: (){},
              child: Container(
                alignment: Alignment.center,
                child: Text("Join",
                style: TextStyle(fontSize: 15.0),),
              )
          ),
          Divider(
            height: 5.0,
          ),
          TextButton(
              onPressed: (){},
              child: Container(
                alignment: Alignment.center,
                child: Text("Create Group",
                  style: TextStyle(fontSize: 15.0),),
              )
          )
        ],
      ),
    );
  });
}