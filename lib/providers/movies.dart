import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../providers/movie.dart';

class Movies with ChangeNotifier {
  final List<Movie> _movies = [];
  int _page = 1;

  List<Movie> get movies {
    return [..._movies];
  }

  List<Movie> get favoriteMovies {
    return _movies.where((movie) => movie.isFavorite).toList();
  }

  Future<void> fetchMovies() async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=4418a4dd7da6409b55bd0876c7540a10&language=en-US&page=$_page');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      extractedData['results'].forEach((movie) {
        _movies.add(Movie(
          id: movie['id'],
          title: movie['title'],
          description: movie['overview'],
          imageUrl:
              'https://image.tmdb.org/t/p/original/${movie['poster_path']}',
          voteAverage: movie['vote_average'] is String
              ? double.parse(movie['vote_average'])
              : (movie['vote_average'] is int
                  ? movie['vote_average'].toDouble()
                  : movie['vote_average']),
        ));
      });
      _page++;
      notifyListeners();
    } catch (ex) {
      throw ex;
    }
  }

  Future<void> refreshMovies() async {
    _movies.clear();
    _page = 1;
    await fetchMovies();
    notifyListeners();
  }
}
