import 'package:flutter/material.dart';
import 'package:giftnest/controller/UserHelper.dart';
import 'package:giftnest/controller/EventHelper.dart';
import 'package:giftnest/controller/FriendshipHelper.dart';
import 'package:giftnest/model/User.dart';
import 'package:giftnest/view/HomePageNavBar.dart';
import 'FriendSearchBar.dart';
import 'FriendList.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EventHelper _eventHelper = EventHelper();
  List<Map<String, dynamic>> _friends = [];
  List<Map<String, dynamic>> _filteredFriends = [];
  final TextEditingController _searchController = TextEditingController();
  User? _currentUser;
  @override
 void initState()  {
    super.initState();
    _loadFriends();
    _searchController.addListener(_filterFriends);
    _fetchCurrentUser();
  }
  void _fetchCurrentUser() async {
    User? user = await UserHelper().getUserById(2);
    setState(() {
      _currentUser = user!;
    });
  }

  Future<void> _loadFriends() async {
    final List<User> allUsers = await FriendshipHelper().getUserFriends(2);
    List<Map<String, dynamic>> friendsData = [];

    for (var user in allUsers) {
      final int upcomingEventsCount =
      await _eventHelper.getUpcomingEventsCountByUserId(user.id);

      friendsData.add({
        'id' : user.id,
        'name': '${user.firstName} ${user.lastName}',
        'photo': user.profileImage,
        'upcomingEvents': upcomingEventsCount,
      });
    }

    setState(() {
      _friends = friendsData;
      _filteredFriends = friendsData;
    });
  }

  void _filterFriends() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFriends = _friends
          .where((friend) => friend['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _currentUser == null
    ? Center(child: CircularProgressIndicator())
        : HomePageNavBar(user: _currentUser!),
      backgroundColor: const Color(0xffececec),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [

          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: FriendSearchBar(_filteredFriends));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add Friend"),
        onPressed: () {
          // Add your action here
        },
        icon: const Icon(Icons.add),
      ),
      body: _filteredFriends.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : FriendList(friends: _filteredFriends),
    );
  }
}
