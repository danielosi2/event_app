import 'package:flutter/material.dart';

class Event {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final String description;
  final String imageUrl;
  bool isAttending;

  Event({
    String? id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.imageUrl,
    this.isAttending = false,
  }) : this.id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  // Create a copy of the event with updated fields
  Event copyWith({
    String? title,
    DateTime? date,
    TimeOfDay? time,
    String? location,
    String? description,
    String? imageUrl,
    bool? isAttending,
  }) {
    return Event(
      id: this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isAttending: isAttending ?? this.isAttending,
    );
  }

  // Convert Event to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'isAttending': isAttending,
    };
  }

  // Create an Event from a Map
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      time: TimeOfDay(
        hour: int.parse(map['time'].split(':')[0]),
        minute: int.parse(map['time'].split(':')[1]),
      ),
      location: map['location'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      isAttending: map['isAttending'],
    );
  }

  @override
  String toString() {
    return 'Event(id: $id, title: $title, date: $date, time: $time, location: $location, description: $description, imageUrl: $imageUrl, isAttending: $isAttending)';
  }
}