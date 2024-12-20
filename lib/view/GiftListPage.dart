import 'package:flutter/material.dart';
import 'package:giftnest/Core/GiftHelper.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:giftnest/model/Gift.dart';

import '../Core/EventHelper.dart';
import '../model/Event.dart';
import '../model/Gift.dart';
import '../model/User.dart';
//import 'AddGiftPage.dart';
//import 'EditGiftPage.dart';
class GiftListPage extends StatefulWidget {
  final String title; // User's first name
  //final List<Gift> gifts; // List of gifts to display
  final List<Event> events; // List of events to display
  final bool isOwnGifts; // Whether it's the logged-in user's gifts
  final User user;
  const GiftListPage({
    super.key,
    required this.title,
    //required this.gifts,
    required this.events,
    required this.user,
    required this.isOwnGifts, // Pass true if it's the current user's gifts
  });

  @override
  State<GiftListPage> createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
   List<Gift> _gifts=[];
   String _title="";

  @override
  void initState() {
    super.initState();
    //_gifts = widget.gifts;
    getGiftsofEvents();
    _title = widget.title;
  }
  Future<void> getGiftsofEvents()async {
    var events = await EventHelper().getEventsByUserId(widget.user.id); // Fetch events
    var gifts = await GiftHelper().getAllUserGiftsById(widget.user.id!,events); // Fetch events
    setState(() {
      _gifts = gifts;
    });
  }
  // Convert String date to DateTime for comparison
  DateTime _parseDate(String date) {
    return DateFormat('yyyy-MM-dd').parse(date);
  }

  // Get status based on date
  String _getStatus(DateTime giftDate) {
    DateTime now = DateTime.now();
    if (giftDate.isAfter(now)) {
      return 'Upcoming';
    } else {
      return 'Past';
    }
  }

  // Sorting function
  void _sortgifts(String criteria) {
    setState(() {
      if (criteria == 'Title') {
        _gifts.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      } else if (criteria == 'Status') {
        _gifts.sort((a, b) => a.status.compareTo(b.status));
      }
    });
  }

  // Gift Actions (Add, Edit, Delete)
  void _addGift() {
    // Show Add Gift Dialog (not implemented in your current code)
  }

  void _editGift(Gift gift, int index) {
    // Show Edit Gift Dialog (not implemented in your current code)
  }

  void _deleteGift(Gift gift) {
    // Delete the gift (not implemented in your current code)
  }

  // Function to get Event by ID
  Event? _getEventById(int eventId) {
    return widget.events.firstWhere((event) => event.id == eventId,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${_title}\'s Gift List'),
        actions: widget.isOwnGifts
            ? [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addGift,
          ),
        ]
            : null,
      ),
      body: Column(
        children: [
          // Sorting Options
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _sortgifts('Title'),
                  child: const Text('Sort by Title'),
                ),
                ElevatedButton(
                  onPressed: () => _sortgifts('Status'),
                  child: const Text('Sort by Status'),
                ),
              ],
            ),
          ),

          // Gift List
          Expanded(
            child: ListView.builder(
              itemCount: _gifts.length,
              itemBuilder: (context, index) {
                final gift = _gifts[index];
                for( var gi in widget.events){
                  print('event id :${gi.id}');
                }
                for( var gi in _gifts){
                  print('gift id :${gi.eventId}');
                  print('gift title :${gi.title}');
                }

                final event = _getEventById(gift.eventId); // Get the event details

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(gift.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${gift.price}\$ - ${gift.status}'),
                        if (event != null)
                          Text('Event: ${event.title}'), // Show event name
                        if (gift.description!=null)
                          Text('${gift.description}'),
                      ],
                    ),
                    trailing: widget.isOwnGifts
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editGift(gift, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteGift(gift),
                        ),
                      ],
                    )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isOwnGifts
          ? FloatingActionButton(
        onPressed: _addGift,
        child: Icon(Icons.cloud_upload),
      )
          : null,
    );
  }
}
