import 'package:flutter/material.dart';
import 'package:movie_app/models/favmovies.dart';
import 'package:movie_app/models/movies.dart';
import 'package:movie_app/screens/favorite_movies.dart';
import 'package:movie_app/screens/movie_catalog.dart';
import 'package:movie_app/screens/movie_details.dart';
import 'package:provider/provider.dart';

import 'common/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MoviesModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => FavModel(),
          ),
        ],
        child: MaterialApp(
          title: 'Movie App',
          theme: appTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => MyCatalog(),
            '/favorites': (context) => MyFavorites(),
            '/details': (context) => DetailScreen(),
          },
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'counter should be here',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/catalog'),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
