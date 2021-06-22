import 'package:bling/config/routes.dart';
import 'package:flutter/material.dart';

class JoinButton extends StatefulWidget {

  @override
  _JoinButtonState createState() => _JoinButtonState();
}

class _JoinButtonState extends State<JoinButton> {
  double _opacity = 1.0;
  bool _isVisible = true;
  @override
  Widget build(BuildContext context) {
    Routes.addPageListener(() {
      if(Routes.page != 1){
        Future.delayed(Duration(milliseconds: 200), (){
          setState(() => _isVisible = false);
        });
        setState(() => _opacity = 0.0);
      }
      else{
        setState(() => _isVisible = true);
        setState(() => _opacity = 1.0);
      }
    });
    return
      AnimatedOpacity(
        opacity: _opacity,
        duration: Duration(milliseconds: 200),
        child: Visibility(
          visible: _isVisible,
          child: FloatingActionButton(
            onPressed: () { },
            child: Icon(Icons.add),
          ),
        ),
      );
  }
}