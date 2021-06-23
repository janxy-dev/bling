import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  final List<Widget>? leading;
  final List<Widget>? action;
  final String? title;
  late String _title;
  late List<Widget> _leading;
  late List<Widget> _action;
  Setting({this.leading, this.action, this.title}){
    _leading = leading ?? [];
    _action = action ?? [];
    _title = title ?? "";
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20.0, right: 10.0),
                width: MediaQuery.of(context).size.width-50.0,
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ..._leading,
                    Text(_title, style: TextStyle(fontSize: 15.0)),
                    ..._action
                  ],
                )
            )
        ),
      ),
    );
  }
}

class ToggleSetting extends StatefulWidget {
  final String title;
  final Function(bool value) onToggled;
  ToggleSetting({required this.title, required this.onToggled});

  @override
  _ToggleSettingState createState() => _ToggleSettingState();
}

class _ToggleSettingState extends State<ToggleSetting> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    return Setting(
      title: widget.title,
      action: [
        Switch(onChanged: (bool value) {
          setState(()=>_value = !_value);
          widget.onToggled(value);
        },value: _value,)
      ],
    );
  }
}