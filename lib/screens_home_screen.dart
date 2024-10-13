import 'package:event_app/models_event.dart';
import 'package:event_app/screens_event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:event_app/widgets_event_card.dart';

class HomeScreen extends StatelessWidget {
  final List<Event> events;
  final Function(Event) onToggleFavorite;

  HomeScreen({required this.events, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Events', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventCard(
            event: events[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailScreen(
                    event: events[index],
                    onToggleFavorite: onToggleFavorite,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
