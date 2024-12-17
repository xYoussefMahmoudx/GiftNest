import 'package:flutter/material.dart';

class FriendSearchBar extends SearchDelegate {
  final List<Map<String, dynamic>> friends;

  FriendSearchBar(this.friends);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Map<String, dynamic>> results = friends
        .where((friend) => friend['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final friend = results[index];
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
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map<String, dynamic>> suggestions = friends
        .where((friend) => friend['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final friend = suggestions[index];
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
          ),
        );
      },
    );
  }
}
