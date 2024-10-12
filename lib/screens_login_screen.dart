import 'package:event_app/models_event.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Theme.of(context).primaryColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => MainScreen(
                            events: [
                              Event(
                                title: 'Flutter Workshop',
                                date: DateTime.now().add(Duration(days: 2)),
                                time: TimeOfDay(hour: 14, minute: 0),
                                location: 'Room 101',
                                description: 'Learn how to build amazing mobile apps with Flutter!',
                                imageUrl: 'https://picsum.photos/seed/flutter/400/200',
                              ),
                              Event(
                                title: 'Campus Hackathon',
                                date: DateTime.now().add(Duration(days: 5)),
                                time: TimeOfDay(hour: 9, minute: 0),
                                location: 'Student Center',
                                description: 'Join us for a 24-hour coding challenge and win prizes!',
                                imageUrl: 'https://picsum.photos/seed/hackathon/400/200',
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
