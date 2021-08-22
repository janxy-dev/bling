import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  late final double width;
  late final double height;
  LoadingAnimation({double? width, double? height}){
    this.width = width ?? 30;
    this.height = height ?? 30;
  }
  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CircularProgressIndicator(
        color: Colors.lightBlueAccent,
      ),
    );
  }
}
