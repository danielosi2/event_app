import 'package:event_app/models_event.dart';
import 'package:event_app/notification.dart';
import 'package:flutter/material.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  final Function(Event) onToggleFavorite;

  EventDetailScreen({required this.event, required this.onToggleFavorite});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.event.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                  )),
              background: widget.event.imageFile != null
                  ? Image.file(
                      widget.event.imageFile!,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      widget.event.imageUrl ?? 'https://picsum.photos/seed/${widget.event.title.hashCode}/800/400',
                      fit: BoxFit.cover,
                    ),
            ),
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
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                  widget.onToggleFavorite(widget.event);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.event.isAttending = !widget.event.isAttending;
                  });
                  if (widget.event.isAttending) {
                    NotificationService().scheduleEventReminder(widget.event);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You will receive a reminder for this event')),
                    );
                  } else {
                    NotificationService().cancelEventReminder(widget.event);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Event reminder cancelled')),
                    );
                  }
                },
                child: Text(widget.event.isAttending ? 'Cancel Attendance' : 'Attend'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.event.isAttending ? Colors.red : Theme.of(context).colorScheme.secondary,
                  minimumSize: Size(200, 50),
                ),
              ),
            ],
          ),
        ),
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
