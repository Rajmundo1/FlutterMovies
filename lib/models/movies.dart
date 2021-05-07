import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoviesModel extends ChangeNotifier {
  ShortingProperty shortingProperty = ShortingProperty.ByDescendingPopularity;
  int itemPerPage = 20;

  MoviesRoot movieStorage = MoviesRoot(1, <Result>[], 20, 1);

  late String searchPhase = "";

  Future<MoviesRoot> fetchMovies() async {
    if (searchPhase.trim().isEmpty)
      return fetchMoviesWithoutSearch();
    else {
      return fetchMoviesWithSearch();
    }
  }

  Future<MoviesRoot> fetchMoviesWithSearch() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=687a50b0d16b236a572c43004ecd1c7f&query=$searchPhase&'
        'page=${movieStorage.page > movieStorage.total_pages ? movieStorage.total_pages.toString() : movieStorage.page.toString()}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var moviesRoot = MoviesRoot.fromJson(jsonDecode(response.body));
      if (moviesRoot.page == 1) {
        movieStorage.results.clear();
      }
      movieStorage.results.addAll(moviesRoot.results);
      movieStorage.total_pages = moviesRoot.total_pages;
      movieStorage.page = moviesRoot.page;
      return moviesRoot;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load movies');
    }
  }

  Future<MoviesRoot> fetchMoviesWithoutSearch() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?'
        'api_key=687a50b0d16b236a572c43004ecd1c7f&language=en-US&'
        'sort_by=${_getShortingString(shortingProperty)}&'
        'include_adult=false&'
        'include_video=false&'
        'page=${movieStorage.page > movieStorage.total_pages ? movieStorage.total_pages.toString() : movieStorage.page.toString()}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var moviesRoot = MoviesRoot.fromJson(jsonDecode(response.body));
      if (moviesRoot.page == 1) {
        movieStorage.results.clear();
      }
      movieStorage.results.addAll(moviesRoot.results);
      movieStorage.total_pages = moviesRoot.total_pages;
      movieStorage.page = moviesRoot.page;
      return moviesRoot;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load movies');
    }
  }

  void search(String value) {
    searchPhase = value;
    movieStorage.page = 1;
    movieStorage.total_pages = 1;
    fetchMovies().then((res) {
      notifyListeners();
    });
  }

  void notify() {
    notifyListeners();
  }

  void incrementPage() {
    if (movieStorage.page + 1 <= movieStorage.total_pages) {
      movieStorage.page = movieStorage.page + 1;
      fetchMovies().then((res) {
        notifyListeners();
      });
    }
  }

  MoviesRoot get getMoviesStorage {
    return movieStorage;
  }

  set setShortingProperty(ShortingProperty value) {
    shortingProperty = value;
    fetchMovies().then((res) {
      notifyListeners();
    });
  }

  ShortingProperty get getShortingProperty {
    return shortingProperty;
  }

  set setCurrentPage(int page) {
    movieStorage.page =
        page > movieStorage.total_pages ? movieStorage.total_pages : page;

    notifyListeners();
  }

  String _getShortingString(ShortingProperty shortingProperty) {
    switch (shortingProperty) {
      case ShortingProperty.ByAscendingPopularity:
        return "popularity.asc";
      case ShortingProperty.ByDescendingPopularity:
        return "popularity.desc";
      case ShortingProperty.ByAscendingVote:
        return "vote_average.asc";
      case ShortingProperty.ByDescendingVote:
        return "vote_average.desc";
      default:
        return "popularity.asc";
    }
  }
}

class Result {
  String? poster_path;
  bool adult;
  String overview;
  String release_date;
  List<int> genre_ids;
  int id;
  String original_title;
  String original_language;
  String title;
  String? backdrop_path;
  double popularity;
  int vote_count;
  bool video;
  double vote_average;

  Result(
      this.poster_path,
      this.adult,
      this.overview,
      this.release_date,
      this.genre_ids,
      this.id,
      this.original_title,
      this.original_language,
      this.title,
      this.backdrop_path,
      this.popularity,
      this.vote_count,
      this.video,
      this.vote_average);

  factory Result.fromJson(Map<String, dynamic> json) {
    var genreIdsDynamicList = json['genre_ids'] as List;
    var genreIdsIntList = new List<int>.from(genreIdsDynamicList);

    var voteAverageDynamic = json['vote_average'];
    var voteAverageDouble = voteAverageDynamic.toDouble();

    var popularityDynamic = json['popularity'];
    var popularityDouble = popularityDynamic.toDouble();

    return Result(
        json['poster_path'],
        json['adult'],
        json['overview'],
        json['release_date'] == null ? "" : json['release_date'],
        genreIdsIntList,
        json['id'],
        json['original_title'],
        json['original_language'],
        json['title'],
        json['backdrop_path'],
        popularityDouble,
        json['vote_count'],
        json['video'],
        voteAverageDouble);
  }
}

class MoviesRoot {
  int page;
  List<Result> results;
  int total_results;
  int total_pages;

  MoviesRoot(this.page, this.results, this.total_results, this.total_pages);

  factory MoviesRoot.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<Result> resultList = list.map((i) => Result.fromJson(i)).toList();

    return MoviesRoot(
        json['page'], resultList, json['total_results'], json['total_pages']);
  }
}

enum ShortingProperty {
  ByAscendingVote,
  ByDescendingVote,
  ByAscendingPopularity,
  ByDescendingPopularity,
}
