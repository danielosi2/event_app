import 'dart:io';
import 'package:flutter/material.dart';

class Event {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final String description;
  final File? imageFile;
  final String? imageUrl;
  bool isAttending;

  Event({
    String? id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    this.imageFile,
    this.imageUrl,
    this.isAttending = false,
  }) : this.id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Event copyWith({
    String? title,
    DateTime? date,
    TimeOfDay? time,
    String? location,
    String? description,
    File? imageFile,
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
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      isAttending: isAttending ?? this.isAttending,
    );
  }
}
