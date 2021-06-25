import 'package:bling/widgets/chat_banner.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Divider(),
        ChatBanner(ValueKey("johndoe")),
        ChatBanner(ValueKey("isuskrist")),
        ChatBanner(ValueKey("retard")),
        ChatBanner(ValueKey("debil")),
      ],
    );
  }
}