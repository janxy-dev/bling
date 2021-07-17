import 'package:bling/core/client.dart';
import 'package:bling/widgets/app_bars.dart';
import 'package:flutter/material.dart';
class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Widget _textField(String label, TextEditingController _controller){
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
  List<String> errors = [];

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
            Column(
              children: errors.map((e) => Text(e, style: TextStyle(color: Colors.red),)).toList()
            ),
            _textField("Username", username),
            _textField("Password", password),
            TextButton(onPressed: (){
              Client.login(username.text, password.text, onSuccess: ()=>Navigator.of(context).pushNamed("/", arguments: Client.token),
              onError: (err){
                setState(() {
                  print(err);
                  errors = err;
                });
              });
            }, child: Text("Log In"))
          ],
        ),
      ),
    );
  }
}