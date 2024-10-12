import 'package:event_app/models_event.dart';
import 'package:event_app/screens_create_event_screen.dart';
import 'package:event_app/screens_favorites_screen.dart';
import 'package:event_app/screens_home_screen.dart';
import 'package:event_app/screens_login_screen.dart';
import 'package:event_app/screens_profile_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Event Tracker',
      theme: ThemeData(
        primaryColor: Color(0xFF3B82F6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF3B82F6),
          secondary: Color(0xFFF97316),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF3B82F6),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF3B82F6),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF3B82F6)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final List<Event> events;

  MainScreen({required this.events});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Event> _favoriteEvents = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addEvent(Event event) {
    setState(() {
      widget.events.add(event);
    });
  }

  void _toggleFavorite(Event event) {
    setState(() {
      if (_favoriteEvents.contains(event)) {
        _favoriteEvents.remove(event);
      } else {
        _favoriteEvents.add(event);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeScreen(events: widget.events, onToggleFavorite: _toggleFavorite),
      FavoritesScreen(favoriteEvents: _favoriteEvents, onToggleFavorite: _toggleFavorite),
      CreateEventScreen(onEventCreated: _addEvent),
      ProfileScreen(),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
