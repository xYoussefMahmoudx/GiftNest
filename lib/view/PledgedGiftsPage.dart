import 'package:flutter/material.dart';
import 'package:giftnest/Core/GiftHelper.dart';
import 'package:giftnest/Core/PledgedGiftHelper.dart';
import 'package:giftnest/model/PledgedGift.dart';
import 'package:giftnest/model/Gift.dart';
import '../Core/EventHelper.dart';
import '../model/Event.dart';
import '../model/User.dart';

class PledgedGiftsPage extends StatefulWidget {
  final User user;

  const PledgedGiftsPage({
    super.key,
    required this.user,
  });

  @override
  State<PledgedGiftsPage> createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {
  List<Event> _events = [];
  List<Gift> _gifts = [];
  List<PledgedGift> _pledgedGifts = [];
  bool _isLoading = true; // To indicate data loading state

  @override
  void initState() {
    super.initState();
    fetchPledgedGifts();
  }

  /// Fetch pledged gifts and related events and gifts data
  Future<void> fetchPledgedGifts() async {
    try {
      var events = await EventHelper().getEventsByUserId(widget.user.id!);
      var pledgedGifts = await PledgedGiftHelper().getPledgedGiftsByUser(widget.user.id!);
      List<Gift> gifts = [];

      for (var pledgedGift in pledgedGifts) {
        var gift = await GiftHelper().getGiftById(pledgedGift.giftId);
        if (gift != null) gifts.add(gift);
      }

      setState(() {
        _events = events;
        _gifts = gifts;
        _pledgedGifts = pledgedGifts;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // Handle error (e.g., show a message to the user)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    }
  }

  /// Get an Event by its ID
  Event? _getEventById(int eventId) {
    return _events.firstWhere((event) => event.id == eventId);
  }

  /// Get a Gift by its ID
  Gift? _getGiftById(int giftId) {
    return _gifts.firstWhere((gift) => gift.id == giftId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget.user.firstName}\'s Pledged Gifts'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pledgedGifts.isEmpty
          ? const Center(child: Text('No pledged gifts found.'))
          : ListView.builder(
        itemCount: _pledgedGifts.length,
        itemBuilder: (context, index) {
          final pledgedGift = _pledgedGifts[index];
          final gift = _getGiftById(pledgedGift.giftId);

          if (gift == null) {
            return const SizedBox.shrink(); // Skip if gift is null
          }

          final event = _getEventById(gift.eventId);

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(gift.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${gift.price}\$ - ${gift.status}'),
                  if (event != null) Text('Event: ${event.title}'),
                  if (gift.description != null)
                    Text('Description: ${gift.description!}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
