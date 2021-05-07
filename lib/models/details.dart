import 'package:flutter/cupertino.dart';

@immutable
class DetailMovie {
  int id;
  String name;
  String genre;
  String imageUrl;
  String yearOfRelease;
  String director;

  DetailMovie(this.id, this.name, this.genre, this.imageUrl, this.yearOfRelease,
      this.director);

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is DetailMovie && other.id == id;
}

class Genre {
  int id;
  String name;

  Genre(this.id, this.name);

  Genre.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

class ProductionCompany {
  int id;
  String? logo_path;
  String name;
  String origin_country;

  ProductionCompany(this.id, this.logo_path, this.name, this.origin_country);

  ProductionCompany.fromjson(Map<String, dynamic> json)
      : id = json['id'],
        logo_path = json['logo_path'],
        name = json['name'],
        origin_country = json['origin_country'];
}

class ProductionCountry {
  String iso_3166_1;
  String name;

  ProductionCountry(this.iso_3166_1, this.name);

  ProductionCountry.fromjson(Map<String, dynamic> json)
      : iso_3166_1 = json['iso_3166_1'],
        name = json['name'];
}

class SpokenLanguage {
  String iso_639_1;
  String name;

  SpokenLanguage(this.iso_639_1, this.name);

  SpokenLanguage.fromjson(Map<String, dynamic> json)
      : iso_639_1 = json['iso_639_1'],
        name = json['name'];
}

class MovieDetailRoot {
  bool adult;
  String? backdrop_path;
  Object? belongs_to_collection;
  int budget;
  List<Genre> genres;
  String? homepage;
  int id;
  String? imdb_id;
  String original_language;
  String original_title;
  String? overview;
  double popularity;
  String? poster_path;
  List<ProductionCompany> production_companies;
  List<ProductionCountry> production_countries;
  String release_date;
  int revenue;
  int? runtime;
  List<SpokenLanguage> spoken_languages;
  String status;
  String? tagline;
  String title;
  bool video;
  double vote_average;
  int vote_count;

  MovieDetailRoot(
      this.adult,
      this.backdrop_path,
      this.belongs_to_collection,
      this.budget,
      this.genres,
      this.homepage,
      this.id,
      this.imdb_id,
      this.original_language,
      this.original_title,
      this.overview,
      this.popularity,
      this.poster_path,
      this.production_companies,
      this.production_countries,
      this.release_date,
      this.revenue,
      this.runtime,
      this.spoken_languages,
      this.status,
      this.tagline,
      this.title,
      this.video,
      this.vote_average,
      this.vote_count);

  factory MovieDetailRoot.fromJson(Map<String, dynamic> json) {
    var list = json['genres'] as List;
    List<Genre> genres = list.map((i) => Genre.fromJson(i)).toList();

    list = json['production_companies'] as List;
    List<ProductionCompany> production_companies =
        list.map((i) => ProductionCompany.fromjson(i)).toList();

    list = json['production_countries'] as List;
    List<ProductionCountry> production_countries =
        list.map((i) => ProductionCountry.fromjson(i)).toList();

    list = json['spoken_languages'] as List;
    List<SpokenLanguage> spoken_languages =
        list.map((i) => SpokenLanguage.fromjson(i)).toList();

    var voteAverageDynamic = json['vote_average'];
    var voteAverageDouble = voteAverageDynamic.toDouble();

    return MovieDetailRoot(
        json['adult'],
        json['backdrop_path'],
        json['belongs_to_collection'],
        json['budget'],
        genres,
        json['homepage'],
        json['id'],
        json['imdb_id'],
        json['original_language'],
        json['original_title'],
        json['overview'],
        json['popularity'],
        json['poster_path'],
        production_companies,
        production_countries,
        json['release_date'],
        json['revenue'],
        json['runtime'],
        spoken_languages,
        json['status'],
        json['tagline'],
        json['title'],
        json['video'],
        voteAverageDouble,
        json['vote_count']);
  }
}
