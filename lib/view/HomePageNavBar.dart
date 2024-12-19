import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giftnest/Core/EventHelper.dart';
import 'package:giftnest/Core/UserHelper.dart';
import 'package:giftnest/view/EventListPage.dart';
import 'package:giftnest/view/ProfilePage.dart';

import '../model/User.dart';

class HomePageNavBar extends StatelessWidget{
  final User user;
HomePageNavBar({
  super.key,
  required this.user// Pass true if it's the current user's events
});
  @override
  Widget build(BuildContext context) {
    return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
        accountName: Text('${user.firstName} ${user.lastName}',style: TextStyle(fontWeight: FontWeight.bold),),
        accountEmail: Text('${user.email}'),
        currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: user.profileImage == null
                  ? SvgPicture.asset("assets/male_avatar.svg", fit: BoxFit.cover) // Fallback to SVG if no avatar
                  : Image.memory(
                user.profileImage!, // Display image from the Blob
                fit: BoxFit.cover, // Ensure image covers the circle fully
                width: double.infinity, // Ensure it covers the entire area
                height: double.infinity, // Ensure it covers the entire area
              ),
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
          onTap: () async {
            // Await the user and event data before navigating
            // Fetch user data
            // Ensure that the user data is available
            if (user != null) {
              // Navigate to EventListPage with the fetched data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                user: user,),
                ),
              );
            } else {
              // Handle the case when the user is not found
              print('User not found');
            }
          },
        ),
        ListTile(
          leading: Icon(Icons.event),
          title: Text('My Events'),
          onTap: () async {
            // Await the user and event data before navigating

            var events = await EventHelper().getEventsByUserId(2); // Fetch events

            // Ensure that the user data is available
            if (user != null) {
              // Navigate to EventListPage with the fetched data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventListPage(
                    title: user.firstName, // Display user's first name in the title
                    events: events,
                    isOwnEvents: true, // true because it's the logged-in user's events
                  ),
                ),
              );
            } else {
              // Handle the case when the user is not found
              print('User not found');
            }
          },
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