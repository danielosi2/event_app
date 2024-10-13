import 'package:event_app/models_event.dart';
import 'package:event_app/notification.dart';
import 'package:event_app/screens_create_event_screen.dart';
import 'package:event_app/screens_favorites_screen.dart';
import 'package:event_app/screens_home_screen.dart';
import 'package:event_app/screens_profile_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Event Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange,
        ),
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Event> _events = [
    Event(
      title: 'Flutter Workshop',
      date: DateTime.now().add(Duration(days: 2)),
      time: TimeOfDay(hour: 14, minute: 0),
      location: 'Room 101',
      description: 'Learn how to build amazing mobile apps with Flutter!',
      imageUrl: 'https://picsum.photos/seed/flutter/800/400',
    ),
    Event(
      title: 'Campus Hackathon',
      date: DateTime.now().add(Duration(days: 5)),
      time: TimeOfDay(hour: 9, minute: 0),
      location: 'Student Center',
      description: 'Join us for a 24-hour coding challenge and win prizes!',
      imageUrl: 'https://picsum.photos/seed/hackathon/800/400',
    ),
  ];

  List<Event> _favoriteEvents = [];
  bool _isLoading = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleFavorite(Event event) {
    setState(() {
      if (_favoriteEvents.contains(event)) {
        _favoriteEvents.remove(event);
        NotificationService().cancelEventReminder(event);
      } else {
        _favoriteEvents.add(event);
        NotificationService().scheduleEventReminder(event);
      }
    });
  }

  Future<void> _addNewEvent(Event newEvent) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a network delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _events.insert(0, newEvent);
      _isLoading = false;
      _selectedIndex = 0; // Switch to the Home screen after adding a new event
    });

    NotificationService().showNewEventNotification(newEvent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              HomeScreen(events: _events, onToggleFavorite: _toggleFavorite),
              FavoritesScreen(favoriteEvents: _favoriteEvents, onToggleFavorite: _toggleFavorite),
              CreateEventScreen(onEventCreated: _addNewEvent),
              ProfileScreen(),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
