import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/details.dart';

class DetailScreen extends StatelessWidget {
  final int? movieId;
  final String? backDropPath;

  DetailScreen({Key? key, this.movieId, this.backDropPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            pinned: true,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Details Page',
                style: TextStyle(color: Colors.white),
              ),
              background: Image.network(
                  'https://image.tmdb.org/t/p/original/$backDropPath',
                  fit: BoxFit.fitWidth),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 2.5,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([_MyDetails(movieId)]),
          )
        ],
      ),
    );
  }
}

class _MyDetails extends StatelessWidget {
  final int? movieId;

  final textStyleTitle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white);
  final textStyleContent =
      TextStyle(fontStyle: FontStyle.italic, fontSize: 16, color: Colors.white);

  _MyDetails(this.movieId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<MovieDetailRoot> getMovieDetails() async {
      String queryString =
          'https://api.themoviedb.org/3/movie/${movieId.toString()}?api_key=687a50b0d16b236a572c43004ecd1c7f&language=en-US';
      final response = await http.get(Uri.parse(queryString));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return MovieDetailRoot.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load movies');
      }
    }

    return FutureBuilder<MovieDetailRoot>(
        future: getMovieDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    snapshot.error.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
            return Container(
              color: Colors.black,
              padding: EdgeInsets.fromLTRB(12, 36, 10, 12),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  //direction: Axis.vertical,
                  //spacing: 15,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            //'Title:',
                            'Title:',
                            textAlign: TextAlign.center,
                            //overflow: TextOverflow.ellipsis,
                            style: textStyleTitle,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      snapshot.data!.title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleContent,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    for (int i = -1; i < snapshot.data!.genres.length; i++)
                      i == -1
                          ? Container(
                              child: Text(
                                'Genre:',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: textStyleTitle,
                              ),
                            )
                          : Container(
                              child: Text(
                                '${snapshot.data!.genres[i].name}',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: textStyleContent,
                              ),
                            ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Release Date:',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleTitle,
                    ),
                    Text(
                      snapshot.data!.release_date,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleContent,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Popularity:',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleTitle,
                    ),
                    Text(
                      snapshot.data!.popularity.toString(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleContent,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    for (int i = -1;
                        i < snapshot.data!.production_companies.length;
                        i++)
                      i == -1
                          ? Text(
                              'Production Company:',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: textStyleTitle,
                            )
                          : Text(
                              '${snapshot.data!.production_companies[i].name}',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: textStyleContent,
                            ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Revenue:',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleTitle,
                    ),
                    Text(
                      '${snapshot.data!.revenue}\$',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleContent,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Budget:',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleTitle,
                    ),
                    Text(
                      '${snapshot.data!.budget}\$',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleContent,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Vote Average:',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleTitle,
                    ),
                    Text(
                      snapshot.data!.vote_average.toString(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleContent,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Vote Count:',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleTitle,
                    ),
                    Text(
                      snapshot.data!.vote_count.toString(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleContent,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
