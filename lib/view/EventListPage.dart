import 'package:flutter/material.dart';
import 'package:giftnest/controller/EventHelper.dart';
import 'package:intl/intl.dart';
import 'package:giftnest/model/Event.dart';
import '../model/User.dart';
import 'AddEventPage.dart';
import 'EditEventPage.dart';
import 'GiftListPage.dart';

class EventListPage extends StatefulWidget {
  final String title;
  final List<Event> events;
  final bool isOwnEvents;
  final User user;
  const EventListPage({
    super.key,
    required this.title,
    required this.events,
    required this.user,
    required this.isOwnEvents,
  });

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  late List<Event> _events;
  late String _title;

  @override
  void initState() {
    super.initState();
    _events = widget.events;
    _title = widget.title;
  }


  DateTime _parseDate(String date) {
    return DateFormat('yyyy-MM-dd').parse(date);
  }


  String _getStatus(DateTime eventDate) {
    DateTime now = DateTime.now();
    if (eventDate.isAfter(now)) {
      return 'Upcoming';
    } else {
      return 'Past';
    }
  }

  // Sorting function
  void _sortEvents(String criteria) {
    setState(() {
      if (criteria == 'Title') {
        _events.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      } else if (criteria == 'Date') {
        _events.sort((a, b) => _parseDate(a.date).compareTo(_parseDate(b.date)));
      } else if (criteria == 'Status') {
        _events.sort((a, b) => _getStatus(_parseDate(a.date)).compareTo(_getStatus(_parseDate(b.date))));
      }
    });
  }


  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) {
        return AddEventPage(
          onAdd: (String title, String location, String? description, String date,String category) {
            setState(() {
              var _newEvent=Event(
                id: null,
                userId: 2,
                title: title,
                date: date,
                location: location,
                description: description,
                category: category,
              );
              EventHelper().insertEvent(_newEvent);
              _events.add(_newEvent);
            });
          },
        );
      },
    );
  }


  void _editEvent(Event event,int index) {
    showDialog(
      context: context,
      builder: (context) {
        return EditEventPage(
              title: event.title,
              description: event.description,
              location: event.location,
              date: event.date,
              category: event.category,
          onEdit:(String title, String location, String? description, String date,String category) {
            setState(() {

              _events.elementAt(index).title=title;
              _events.elementAt(index).date= date;
              _events.elementAt(index).location= location;
              _events.elementAt(index).description= description;
              _events.elementAt(index).category= category;
              EventHelper().updateEvent(_events.elementAt(index));
            });
          },
        );
      },
    );
  }

  void _deleteEvent(Event event) {
    EventHelper().deleteEvent(event.id);
    setState(() {
      _events.remove(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${_title}\'s Event List'),
        actions: widget.isOwnEvents
            ? [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addEvent,
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
                  onPressed: () => _sortEvents('Title'),
                  child: const Text('Sort by Title'),
                ),
                ElevatedButton(
                  onPressed: () => _sortEvents('Date'),
                  child: const Text('Sort by Date'),
                ),
                ElevatedButton(
                  onPressed: () => _sortEvents('Status'),
                  child: const Text('Sort by Status'),
                ),
              ],
            ),
          ),

          // Event List
          Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                DateTime eventDate = _parseDate(event.date);
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GiftListPage(
                            title: _title,
                            user: widget.user,
                            events: [event],
                            isOwnGifts: widget.isOwnEvents,
                          ),
                        ),
                      );
                    },
                    title: Text(event.title),
                    subtitle: Text(
                      '${event.location} - ${_getStatus(eventDate)}\n${event.description}',
                    ),
                    trailing: widget.isOwnEvents
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editEvent(event,index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteEvent(event),
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
      floatingActionButton: widget.isOwnEvents
          ? FloatingActionButton(
                onPressed: null,
               child: Icon(Icons.cloud_upload)
      ):null,
    );
  }
}
