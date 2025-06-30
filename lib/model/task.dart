import 'dart:convert';
import 'package:flutter/material.dart';

class Task {
  String title;
  DateTime time;
  Color color;
  bool done;
  String? note;

  Task({
    required this.title,
    required this.time,
    this.color = Colors.blue,
    this.done = false,
    this.note,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] as String,
      time: DateTime.parse(map['time'] as String),
      color: Color(map['color'] as int),
      done: map['done'] as bool? ?? false,
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'time': time.toIso8601String(),
      'color': color.value,
      'done': done,
      'note': note,
    };
  }

  static List<String> encode(List<Task> tasks) {
    return tasks.map((t) => json.encode(t.toMap())).toList();
  }

  static List<Task> decode(List<String> tasks) {
    return tasks
        .map((s) => Task.fromMap(json.decode(s) as Map<String, dynamic>))
        .toList();
  }
}
