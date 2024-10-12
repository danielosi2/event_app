import 'package:event_app/models_event.dart';
import 'package:flutter/material.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  final Function(Event) onToggleFavorite;

  EventDetailScreen({required this.event, required this.onToggleFavorite});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.event.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                  )),
              background: Image.network(
                widget.event.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {
                  widget.onToggleFavorite(widget.event);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Event added to favorites'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.calendar_today, 'Date', '${widget.event.date.toString().split(' ')[0]}'),
                  SizedBox(height: 8),
                  _buildInfoRow(Icons.access_time, 'Time', '${widget.event.time.format(context)}'),
                  SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on, 'Location', widget.event.location),
                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.event.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.event.isAttending = !widget.event.isAttending;
                      });
                    },
                    child: Text(widget.event.isAttending ? 'Cancel Attendance' : 'Attend'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.event.isAttending ? Colors.red : Theme.of(context).colorScheme.secondary,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.secondary),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}
