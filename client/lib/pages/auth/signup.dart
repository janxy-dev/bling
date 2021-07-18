import 'package:bling/core/client.dart';
import 'package:bling/core/models/RegisterModel.dart';
import 'package:bling/widgets/app_bars.dart';
import 'package:flutter/material.dart';
class SignupPage extends StatefulWidget {

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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

  List<String> errors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(preferredSize: Size.fromHeight(56.0),
          child: SettingsAppBar("")),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/4,
              width: 200.0,
              padding: EdgeInsets.only(bottom: 10.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: errors.map((e) => Text(e, style: TextStyle(color: Colors.red),)).toList()
              ),
            ),
            textField("Username", username),
            textField("Email", email),
            textField("Password", password),
            textField("Confirm Password", conPassword),
            TextButton(onPressed: (){
              Client.register(RegisterModel(username.text, email.text, password.text, conPassword.text), onSuccess: ()=>Navigator.of(context).pushNamed("/", arguments: Client.token),
              onError: (err){
                setState(() {
                  errors = err;
                });
              });
            }, child: Text("Sign up"))
          ],
        ),
      ),
    );
  }
}