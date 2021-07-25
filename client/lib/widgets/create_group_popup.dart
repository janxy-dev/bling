import 'package:bling/core/client.dart';
import 'package:flutter/material.dart';

dynamic showCreateGroupPopup(BuildContext context){
  TextEditingController _groupName = TextEditingController();
  showDialog(context: context,
      barrierColor: Colors.white.withOpacity(0),
      builder: (_){
        return AlertDialog(
            elevation: 0,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Group Name"),
                TextField(autocorrect: false, controller: _groupName,),
                TextButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Client.createGroup(_groupName.text);
                }, child: Text("Create"))
              ],
            )
        );
      });
}