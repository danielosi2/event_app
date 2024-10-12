import 'package:event_app/models_event.dart';
import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  final Function(Event) onEventCreated;

  CreateEventScreen({required this.onEventCreated});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  String _location = '';
  String _description = '';
  String _imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Event Title',
                prefixIcon: Icon(Icons.title, color: Theme.of(context).primaryColor),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an event title';
                }
                return null;
              },
              onSaved: (value) => _title = value!,
            ),
            SizedBox(height: 16),
            _buildDateTimePicker(
              label: 'Date',
              value: _date.toString().split(' ')[0],
              icon: Icons.calendar_today,
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (pickedDate != null) {
                  setState(() {
                    _date = pickedDate;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            _buildDateTimePicker(
              label: 'Time',
              value: _time.format(context),
              icon: Icons.access_time,
              onTap: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _time,
                );
                if (pickedTime != null) {
                  setState(() {
                    _time = pickedTime;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Location',
                prefixIcon: Icon(Icons.location_on, color: Theme.of(context).primaryColor),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
              onSaved: (value) => _location = value!,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Event Description',
                prefixIcon: Icon(Icons.description, color: Theme.of(context).primaryColor),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an event description';
                }
                return null;
              },
              onSaved: (value) => _description = value!,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Image URL',
                prefixIcon: Icon(Icons.image, color: Theme.of(context).primaryColor),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an image URL';
                }
                return null;
              },
              onSaved: (value) => _imageUrl = value!,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final newEvent = Event(
                    title: _title,
                    date: _date,
                    time: _time,
                    location: _location,
                    description: _description,
                    imageUrl: _imageUrl,
                  );
                  widget.onEventCreated(newEvent);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Event created successfully!')),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Create Event'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        child: Text(value),
      ),
    );
  }
}
