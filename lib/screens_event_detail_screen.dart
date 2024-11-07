import 'package:event_app/models_event.dart';
import 'package:event_app/notification.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  final Function(Event) onToggleFavorite;

  EventDetailScreen({required this.event, required this.onToggleFavorite});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool isFavorite = false;
  bool isAttending = false; // To track attendance

  @override
  void initState() {
    super.initState();
    isAttending = widget.event.isAttending; // Initial attendance state from event data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xFF3F51B5), // Purple theme background
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white), // Back button set to white
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.event.title,
                  style: GoogleFonts.poppins(
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
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F51B5), // Using purple theme for headers
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.event.description,
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Row(
          children: [
            // Heart Icon with border and purple theme
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF3F51B5)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Color(0xFF3F51B5), // Purple for the heart icon
                ),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                  widget.onToggleFavorite(widget.event);
                },
              ),
            ),
            SizedBox(width: 16), // Spacing between heart icon and button

            // Full-width Button with dynamic color and text
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAttending = !isAttending;
                  });
                  if (isAttending) {
                    NotificationService().scheduleEventReminder(widget.event, context); // Pass context as the second argument
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You are now attending this event. Reminder set!')), // Added reminder confirmation
                    );
                  } else {
                    NotificationService().cancelEventReminder(widget.event);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You are no longer attending this event. Reminder cancelled.')), // Added cancellation confirmation
                    );
                  }
                },
                child: Text(
                  isAttending ? 'Attending' : 'Not Attending', // Dynamic button text
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAttending ? Colors.red : Color(0xFF3F51B5), // Changes between red (Not Attending) and purple (Attend)
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded button
                  ),
                  elevation: 5, // Shadow effect for the button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF3F51B5)), // Purple icons for consistency
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        Text(value, style: GoogleFonts.poppins()),
      ],
    );
  }
}
