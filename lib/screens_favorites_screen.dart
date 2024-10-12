import 'package:event_app/models_event.dart';
import 'package:event_app/screens_event_detail_screen.dart';
import 'package:event_app/widgets_event_card.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Event> favoriteEvents;
  final Function(Event) onToggleFavorite;

  FavoritesScreen({required this.favoriteEvents, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: favoriteEvents.isEmpty
          ? Center(
              child: Text('No favorite events yet.'),
            )
          : ListView.builder(
              itemCount: favoriteEvents.length,
              itemBuilder: (context, index) {
                return EventCard(
                  event: favoriteEvents[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(
                          event: favoriteEvents[index],
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
