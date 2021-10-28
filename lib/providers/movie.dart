import 'package:flutter/foundation.dart';

class Movie with ChangeNotifier {
  final int id;
  final String title;
  final String description;
  final double voteAverage;
  final String imageUrl;
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.voteAverage,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
