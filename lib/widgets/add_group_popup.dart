import 'package:bling/widgets/join_group_popup.dart';
import 'package:flutter/material.dart';

dynamic showAddGroupPopup(BuildContext context){
  showDialog(context: context, builder: (_){
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
              onPressed: (){
                showJoinGroupPopup(context);
              },
                child: Text("Join",
                style: TextStyle(fontSize: 15.0),),
            ),
          Divider(
            height: 5.0,
          ),
          TextButton(
            onPressed: (){},
              child: Text("Create Group",
                style: TextStyle(fontSize: 15.0),),
            )
        ],
      ),
    );
  });
}