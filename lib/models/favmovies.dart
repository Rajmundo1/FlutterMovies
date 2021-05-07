import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/details.dart';
import 'package:movie_app/models/movies.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavModel extends ChangeNotifier {
  late MoviesModel _movies;
  List<MovieDetailRoot> favMovies = <MovieDetailRoot>[];

  final List<int> _itemIds = [];

  MoviesModel get movies => _movies;

  FavModel() {
    SharedPreferences.getInstance().then((res) {
      loadFavorites(res.getStringList("itemIds")!);
    });
  }

  set catalog(MoviesModel newCatalog) {
    _movies = newCatalog;
    notifyListeners();
  }

  List<int> get itemIds => _itemIds;

  void loadFavorites(List<String> ids) {
    var idsInt = ids.map((id) => int.parse(id)).toList();

    idsInt.forEach((element) {
      add(element);
    });
  }

  void add(int movieId) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${movieId.toString()}?api_key=687a50b0d16b236a572c43004ecd1c7f&language=en-US'));

    if (response.statusCode == 200) {
      _itemIds.add(movieId);
      favMovies.add(MovieDetailRoot.fromJson(jsonDecode(response.body)));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var stringList = itemIds.map((item) => item.toString()).toList();
      await prefs.setStringList('itemIds', stringList);
    } else
      throw Exception('Failed to load movies');

    notifyListeners();
  }

  void remove(int movieId) async {
    _itemIds.remove(movieId);
    favMovies.removeWhere((element) => element.id == movieId);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var stringList = itemIds.map((item) => item.toString()).toList();
    await prefs.setStringList('itemIds', stringList);

    notifyListeners();
  }
}
