import 'package:flutter/material.dart';

class ProjectModel {
  final String id;
  String title;
  final String date;
  final String size;
  final String duration;
  final String type;
  final Color coverColor;
  final String? subtitle;

  ProjectModel({
    required this.id,
    required this.title,
    required this.date,
    required this.size,
    required this.duration,
    required this.type,
    required this.coverColor,
    this.subtitle,
  });

  ProjectModel copyWith({
    String? id,
    String? title,
    String? date,
    String? size,
    String? duration,
    String? type,
    Color? coverColor,
    String? subtitle,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      size: size ?? this.size,
      duration: duration ?? this.duration,
      type: type ?? this.type,
      coverColor: coverColor ?? this.coverColor,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  static List<ProjectModel> getInitialProjects() {
    return [
      ProjectModel(
        id: '1',
        title: 'trend at 09.00',
        date: '17/10/2026 02:17',
        size: '4MB',
        duration: '00:19',
        type: 'video',
        coverColor: const Color(0xFF1E1E2C),
      ),
      ProjectModel(
        id: '2',
        title: '1012-01',
        date: '12/10/2026 21:44',
        size: '17MB',
        duration: '00:49',
        type: 'video',
        coverColor: const Color(0xFF8D6E63),
      ),
      ProjectModel(
        id: '3',
        title: '3 PIC',
        date: '09/10/2026 14:58',
        size: '10MB',
        duration: '00:24',
        type: 'photo',
        coverColor: const Color(0xFF455A64),
      ),
      ProjectModel(
        id: '4',
        title: 'frame aesthetic',
        date: '09/10/2026 14:54',
        size: '10MB',
        duration: '00:28',
        type: 'video',
        coverColor: const Color(0xFF37474F),
      ),
    ];
  }
}
