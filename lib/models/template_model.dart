import 'package:flutter/material.dart';

class TemplateModel {
  final String id;
  final String title;
  final String author;
  final String uses;
  final String category;
  final String? imagePath;
  final Color primaryColor;
  final Color secondaryColor;
  final String quoteOrLabel;
  final String audioName;

  TemplateModel({
    required this.id,
    required this.title,
    required this.author,
    required this.uses,
    required this.category,
    this.imagePath,
    this.primaryColor = const Color(0xFF1E1F38),
    this.secondaryColor = const Color(0xFF0F1026),
    this.quoteOrLabel = '',
    this.audioName = 'Sound Original - CapCut',
  });

  static List<TemplateModel> getSampleTemplates() {
    return [
      TemplateModel(
        id: '1',
        title: 'JJ',
        author: 'Ronaldo',
        uses: '10.5K',
        category: 'For you',
        imagePath: 'assets/images/jokowi.jpg',
        quoteOrLabel: 'Hidup Jokowi',
      ),
      TemplateModel(
        id: '2',
        title: 'JJ',
        author: 'Kaka',
        uses: '10K',
        category: 'Trending',
        imagePath: 'assets/images/prabowo.jpg',
        quoteOrLabel: 'Orang Desa Ga Pake Dolar',
      ),
    ];
  }
}
