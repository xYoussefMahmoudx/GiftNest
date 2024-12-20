import 'package:flutter/material.dart';
import 'package:giftnest/controller/GiftHelper.dart';
import 'package:giftnest/controller/PledgedGiftHelper.dart';
import 'package:giftnest/model/PledgedGift.dart';
import 'package:giftnest/view/GiftDetailsPage.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:giftnest/model/Gift.dart';
import 'dart:typed_data';
import '../controller/EventHelper.dart';
import '../controller/UserHelper.dart';
import '../model/Event.dart';
import '../model/User.dart';
import 'AddGiftPage.dart';
import 'EditGiftPage.dart';

class GiftListPage extends StatefulWidget {
  final String title;
  final List<Event> events;
  final bool isOwnGifts;
  final User user;
  const GiftListPage({
    super.key,
    required this.title,
    required this.events,
    required this.user,
    required this.isOwnGifts,

  });

  @override
  State<GiftListPage> createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
   User _currentUser=User(firstName: "", lastName: "", email: "");
   List<Gift> _gifts=[];
   String _title="";

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
    getGiftsofEvents();
    _title = widget.title;
  }
   void _fetchCurrentUser() async {
     User? user = await UserHelper().getUserById(2);
     setState(() {
       _currentUser = user!;
     });
   }
  Future<void> getGiftsofEvents()async {
    var events = await EventHelper().getEventsByUserId(widget.user.id);
    var gifts = await GiftHelper().getAllUserGiftsById(widget.user.id!,events);
    setState(() {
      _gifts = gifts;
    });
  }

  // Sorting function
  void _sortgifts(String criteria) {
    setState(() {
      if (criteria == 'Title') {
        _gifts.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      } else if (criteria == 'Status') {
        _gifts.sort((a, b) => a.status.compareTo(b.status));
      }
      else if (criteria == 'Category') {
        _gifts.sort((a, b) => a.category.compareTo(b.category));
      }
    });
  }


  void _addGift() {
    showDialog(
      context: context,
      builder: (context) {
        return AddGiftPage(
          events: widget.events,
          onAdd: (int eventId, String title, String? description, double price, String status,String category,Uint8List giftImage){
            setState(() {
              var _newGift=Gift(
                image: giftImage,
                eventId: eventId,
                title: title,
                description: description,
                price: price,
                status: status,
                category: category,

              );
              GiftHelper().insertGift(_newGift);
              _gifts.add(_newGift);
            });
          },
        );
      },
    );
  }

   void _editGift(Gift gift, int index) {
     showDialog(
       context: context,
       builder: (context) {
         return EditGiftPage(
           giftImage: gift.image!,
           events:widget.events ,
           eventId: gift.eventId,
           title: gift.title,
           description: gift.description,
           price: gift.price,
           category: gift.category,
           status: gift.status,
           onEdit: (int eventId, String title, String? description, double price, String status,String category,Uint8List giftImage) {
             setState(() {
               _gifts[index].image=giftImage;
               _gifts[index].eventId=eventId;
               _gifts[index].title = title;
               _gifts[index].description = description;
               _gifts[index].price = price;
               _gifts[index].status = status;
               _gifts[index].category=category;
               GiftHelper().updateGift(_gifts[index]);

             });
           },
         );
       },
     );
   }

   void _pledgeGift(Gift gift){
    gift.status="Pledged";
    GiftHelper().updateGift(gift);
    PledgedGiftHelper().insertPledgedGift(PledgedGift(userId: _currentUser.id!, giftId: gift.id!));
    setState(() {

    });
   }
   void _deleteGift(Gift gift) {
   GiftHelper().deleteGift(gift.id);
   setState(() {
     _gifts.remove(gift);
   });

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
            padding: const EdgeInsets.all(4.0),
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
                ElevatedButton(
                  onPressed: () => _sortgifts('Category'),
                  child: const Text('Sort by Cat'),
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
                final event = _getEventById(gift.eventId);
                return Card(
                  margin: const EdgeInsets.all(8.0),

                  child: ListTile(
                    tileColor: gift.status!="Pledged"?Colors.white:Colors.green,
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
                        : gift.status!="Pledged"? IconButton(
                      icon: const Icon(Icons.card_giftcard_sharp),
                      onPressed: () => _pledgeGift(gift),
                    )
                    :Icon(Icons.done,),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiftDetailsPage(gift: gift,),
                      ),
                    );
                  },
                )
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
