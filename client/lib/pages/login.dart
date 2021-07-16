import 'package:bling/core/client.dart';
import 'package:flutter/material.dart';
class LoginPage extends StatelessWidget {

  Widget getTextField(String label, TextEditingController _controller){
    return Container(
      height: 26.0,
      width: 200.0,
      margin: EdgeInsets.only(top: 5.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),

        ),
        controller: _controller,
      ),
    );
  }

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getTextField("Username", username),
            getTextField("Password", password),
            TextButton(onPressed: (){
              Client.login(username.text, password.text);
              Future.doWhile(() async {
                if(Client.token.length == 36){
                  Navigator.of(context).pushNamed("/", arguments: Client.token);
                  return false;
                }
                await Future.delayed(Duration(milliseconds: 20));
                return true;
              });
            }, child: Text("Log In"))
          ],
        ),
      ),
    );
  }
}