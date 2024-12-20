import 'package:flutter/material.dart';

import '../Core/EventHelper.dart';
import '../Core/UserHelper.dart';
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
              // Await the user and event data before navigating
              print(friend['id'].toString());
              var user = await UserHelper().getUserById(friend['id']); // Fetch user data
              var events = await EventHelper().getEventsByUserId(friend['id']); // Fetch events

              // Ensure that the user data is available
              if (user != null) {
                // Navigate to EventListPage with the fetched data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventListPage(
                      user: user,
                      title: user.firstName, // Display user's first name in the title
                      events: events,
                      isOwnEvents: false, // true because it's the logged-in user's events
                    ),
                  ),
                );
              } else {
                // Handle the case when the user is not found
                print('User not found');
              }
            },
          ),
        );
      },
    );
  }
}
