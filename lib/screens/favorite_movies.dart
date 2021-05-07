import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/favmovies.dart';
import 'package:movie_app/screens/movie_details.dart';
import 'package:provider/provider.dart';

class MyFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites', style: Theme.of(context).textTheme.headline1),
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _FavList(),
              ),
            ),
            Divider(height: 4, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

class _FavList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FavoriteItems();
  }
}

class _FavoriteItems extends StatelessWidget {
  _FavoriteItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var favorites = context.watch<FavModel>();

    return ListView.builder(
      itemCount: favorites.favMovies.length,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
            color: Colors.black,
            border:
                Border(bottom: BorderSide(color: Colors.white, width: 0.5))),
        padding: EdgeInsets.only(bottom: 10, top: 10),
        child: ListTile(
          leading: Icon(Icons.done, color: Colors.yellow),
          trailing: IconButton(
            icon: Icon(Icons.remove_circle_outline, color: Colors.yellow),
            onPressed: () {
              favorites.remove(favorites.favMovies[index].id);
            },
          ),
          title: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                        movieId: favorites.favMovies[index].id,
                        backDropPath: favorites.favMovies[index].backdrop_path),
                  ));
            },
            child: Text(
              favorites.favMovies[index].title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'roboto',
                  letterSpacing: 0.15),
            ),
          ),
        ),
      ),
    );
  }
}
