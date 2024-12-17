import 'package:flutter/material.dart';
import 'package:giftnest/view/HomePageNavBar.dart';
import 'package:giftnest/Core/UserHelper.dart';
import 'package:giftnest/Core/EventHelper.dart';

import '../Core/FriendshipHelper.dart';
import '../model/User.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserHelper _userHelper = UserHelper();
  final EventHelper _eventHelper = EventHelper();
  List<Map<String, dynamic>> _friends = []; // To store friends and their event data

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    // Fetch all users from the UserHelper
    final List<User> allUsers = await FriendshipHelper().getUserFriends(2);
    List<Map<String, dynamic>> friendsData = [];

    for (var user in allUsers) {
      // Get the count of upcoming events for each user
      final int upcomingEventsCount =
      await _eventHelper.getUpcomingEventsCountByUserId(user.id);

      friendsData.add({
        'name': '${user.firstName} ${user.lastName}',
        'photo': user.profileImage,
        'upcomingEvents': upcomingEventsCount,
      });
    }

    setState(() {
      _friends = friendsData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffececec) ,
      endDrawer:  HomePageNavBar(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add Friend"),
        onPressed: null, // Add your action here
        icon: const Icon(Icons.add),
      ),
      body: _friends.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _friends.length,
        itemBuilder: (context, index) {
          final friend = _friends[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
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
            )
          );
        },
      ),
    );
  }
}
