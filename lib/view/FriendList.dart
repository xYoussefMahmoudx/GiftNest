import 'package:flutter/material.dart';

import '../controller/EventHelper.dart';
import '../controller/UserHelper.dart';
import 'EventListPage.dart';

class FriendList extends StatelessWidget {
  final List<Map<String, dynamic>> friends;

  const FriendList({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          elevation: 4,
          color: Colors.white,
          child: ListTile(
            leading: friend['photo'] != null
                ? CircleAvatar(
              backgroundImage: MemoryImage(friend['photo']),
            )
                : const CircleAvatar(child: Icon(Icons.person)),
            title: Text(friend['name']),
            subtitle: Text('Upcoming Events: ${friend['upcomingEvents']}'),
            onTap: () async {
              print(friend['id'].toString());
              var user = await UserHelper().getUserById(friend['id']);
              var events = await EventHelper().getEventsByUserId(friend['id']);


              if (user != null) {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventListPage(
                      user: user,
                      title: user.firstName,
                      events: events,
                      isOwnEvents: false,
                    ),
                  ),
                );
              } else {

                print('User not found');
              }
            },
          ),
        );
      },
    );
  }
}
