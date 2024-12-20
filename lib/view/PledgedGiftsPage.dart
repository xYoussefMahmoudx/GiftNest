import 'package:flutter/material.dart';
import 'package:giftnest/controller/GiftHelper.dart';
import 'package:giftnest/controller/PledgedGiftHelper.dart';
import 'package:giftnest/model/PledgedGift.dart';
import 'package:giftnest/model/Gift.dart';
import '../controller/EventHelper.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPledgedGifts();
  }


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
        _gifts = gifts;
        _events = events;

        _pledgedGifts = pledgedGifts;
        _isLoading = false;
        for(var gift in pledgedGifts){
          print("pledge id ${gift.giftId.runtimeType.toString()}");
        }
        print("gift length  ${gifts.length.toString()}");
        for(var gift in _gifts){
          print("gift id ${gift.id.runtimeType.toString()}");
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    }
  }


  Event? _getEventById(int eventId) {

    for (var event in _events){
      if(event.id == eventId)
        return event;
    }
  }

  /// Get a Gift by its ID
  Gift? _getGiftById(int giftId) {
    for (var gift in _gifts){
      if(gift.id == giftId)
        return gift;
    }
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
          print(gift?.id);

          if (gift == null) {
            return const SizedBox.shrink();
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
