import 'package:event_app/models_event.dart';
import 'package:event_app/screens_event_detail_screen.dart';
import 'package:event_app/widgets_event_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final List<Event> events;
  final Function(Event) onToggleFavorite;

  HomeScreen({required this.events, required this.onToggleFavorite});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> filteredEvents = [];

  @override
  void initState() {
    super.initState();
    filteredEvents = widget.events;
  }

  void _filterEvents(String query) {
    setState(() {
      filteredEvents = widget.events.where((event) => event.title.toLowerCase().contains(query.toLowerCase()) || event.description.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Events', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterEvents,
              decoration: InputDecoration(
                labelText: 'Search events',
                prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                return EventCard(
                  event: filteredEvents[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(
                          event: filteredEvents[index],
                          onToggleFavorite: widget.onToggleFavorite,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
