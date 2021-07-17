import 'package:bling/core/client.dart';
import 'package:bling/widgets/app_bars.dart';
import 'package:flutter/material.dart';
class SignupPage extends StatelessWidget {

  Widget textField(String label, TextEditingController _controller){
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
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController conPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(preferredSize: Size.fromHeight(56.0),
          child: SettingsAppBar("")),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textField("Username", username),
            textField("Email", email),
            textField("Password", password),
            textField("Confirm Password", conPassword),
            TextButton(onPressed: (){
              Client.register(username.text, email.text, password.text, conPassword.text, onSuccess: ()=>Navigator.of(context).pushNamed("/", arguments: Client.token),
              onError: (err)=>print(err));
            }, child: Text("Sign up"))
          ],
        ),
      ),
    );
  }
}