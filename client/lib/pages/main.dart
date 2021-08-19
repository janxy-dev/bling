import 'package:bling/config/routes.dart';
import 'package:bling/core/client.dart';
import 'package:bling/core/models/group.dart';
import 'package:bling/core/storage.dart';
import 'package:bling/widgets/add_group_button.dart';
import 'package:bling/widgets/app_bars.dart';
import 'package:flutter/material.dart';

import 'main/chats.dart';
import 'main/friends.dart';
import 'main/profile.dart';

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    Client.onUserFetch = (){setState(() {});};
    Client.fetchUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
          //Status bar
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).padding.top,
            color: Theme.of(context).primaryColor,
          ),

          Expanded(
            child: NestedScrollView(
                headerSliverBuilder: (BuildContext context,
                    bool innerBoxIsScrolled) {
                  return [
                    PrimaryAppBar(),
                  ];
                },
                body: Column(
                  children: [
                    SecondaryAppBar(),
                    Expanded(
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        controller: Routes.pageCtrl,
                        children: [
                          FriendsPage(),
                          ChatsPage(Routes.groups),
                          ProfilePage()
                        ],
                      ),
                    )
                  ],
                )
            ),
          ),
        ],
      ),

      floatingActionButton: AddGroupButton(),
    );
  }
}
