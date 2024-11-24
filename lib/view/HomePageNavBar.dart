import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePageNavBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
        accountName: Text("Youssef Mahmoud Ahmed"),
        accountEmail: Text("youssef@gmail.com"),
        currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: SvgPicture.asset("assets/male_avatar.svg",fit: BoxFit.cover,),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.purple,
          image:DecorationImage(
            image: AssetImage("assets/menu_cover.jpg"),
            fit:  BoxFit.cover,
          )

        ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
          onTap: null,
        ),
        ListTile(
          leading: Icon(Icons.event),
          title: Text('My Events'),
          onTap: null,
        ),
        ListTile(
          leading: Icon(Icons.card_giftcard),
          title: Text('My Gifts'),
          onTap: null,
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text('Pledged Gifts'),
          onTap: null,
        ),
      ],
    ),
    );
  }

}