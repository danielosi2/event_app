import 'package:event_app/models_event.dart';
import 'package:event_app/notification.dart';
import 'package:event_app/screens_create_event_screen.dart';
import 'package:event_app/screens_favorites_screen.dart';
import 'package:event_app/screens_home_screen.dart';
import 'package:event_app/screens_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets are initialized
  await NotificationService().init(); // Initialize the notification service
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Event Tracker',
      theme: ThemeData(
        primaryColor: Color(0xFF3F51B5),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
          accentColor: Color(0xFF3F51B5),
        ).copyWith(
          secondary: Color(0xFF3F51B5),
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF3F51B5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF3F51B5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
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
  final List<Event> _events = [
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
        NotificationService().scheduleEventReminder(event, context); // Passing context for notification
      }
    });
  }

  void _addNewEvent(Event newEvent) {
    setState(() {
      _events.insert(0, newEvent);
    });
    NotificationService().showNewEventNotificationAsReminder(newEvent, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(events: _events, onToggleFavorite: _toggleFavorite),
          FavoritesScreen(favoriteEvents: _favoriteEvents, onToggleFavorite: _toggleFavorite),
          CreateEventScreen(onEventCreated: _addNewEvent),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_rounded),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF3F51B5),
          unselectedItemColor: Colors.grey[600],
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
