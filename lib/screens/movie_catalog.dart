import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_app/models/favmovies.dart';
import 'package:movie_app/models/movies.dart';
import 'package:movie_app/screens/movie_details.dart';
import 'package:provider/provider.dart';

class MyCatalog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var movies = context.read<MoviesModel>();

    var searchController = new TextEditingController();
    searchController.text = movies.searchPhase;

    var future = movies.fetchMovies();

    return Scaffold(
      appBar: AppBar(
        title: Text("Discover Movies",
            style: Theme.of(context).textTheme.headline1),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.search),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  side: BorderSide(color: Colors.white, width: 1)),
              color: Colors.black,
              itemBuilder: (context) => [
                    PopupMenuItem(
                        child: Container(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          color: Colors.yellow,
                          onPressed: () {
                            searchController.clear();
                            movies.search("");
                          },
                        )),
                        controller: searchController,
                        style: TextStyle(color: Colors.white),
                        autofocus: true,
                        onSubmitted: (text) {
                          movies.search(text);
                          Navigator.pop(context);
                        },
                      ),
                    ))
                  ]),
          PopupMenuButton(
              enabled: context.select<MoviesModel, bool>(
                  (model) => model.searchPhase.trim().isEmpty),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  side: BorderSide(color: Colors.white, width: 1)),
              color: Colors.black,
              itemBuilder: (context) => [
                    PopupMenuItem(
                        child: Container(
                      child: Column(
                        children: [
                          Align(
                            child: Text("Sorting: ",
                                style: TextStyle(color: Colors.white)),
                            alignment: Alignment.centerLeft,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Radio(
                                value: ShortingProperty.ByAscendingVote,
                                groupValue: movies.getShortingProperty,
                                onChanged: (value) {
                                  movies.setShortingProperty =
                                      value as ShortingProperty;
                                  Navigator.pop(context);
                                },
                              ),
                              Text(
                                "By Ascending Vote",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: ShortingProperty.ByDescendingVote,
                                groupValue: movies.getShortingProperty,
                                onChanged: (value) {
                                  movies.setShortingProperty =
                                      value as ShortingProperty;
                                  Navigator.pop(context);
                                },
                              ),
                              Text("By Descending Vote",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: ShortingProperty.ByAscendingPopularity,
                                groupValue: movies.getShortingProperty,
                                onChanged: (value) {
                                  movies.setShortingProperty =
                                      value as ShortingProperty;
                                  Navigator.pop(context);
                                },
                              ),
                              Text("By Ascending Popularity",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: ShortingProperty.ByDescendingPopularity,
                                groupValue: movies.getShortingProperty,
                                onChanged: (value) {
                                  movies.setShortingProperty =
                                      value as ShortingProperty;
                                  Navigator.pop(context);
                                },
                              ),
                              Text("By Descending Popularity",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          )
                        ],
                      ),
                    ))
                  ]),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<MoviesRoot>(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return _MoviesItems();
                    } else {
                      return Container(
                        color: Colors.black,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final int? itemId;

  const _AddButton({this.itemId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isInFavorites = context.select<FavModel, bool>(
      (favStore) => favStore.itemIds.length != 0
          ? favStore.itemIds.contains(itemId)
          : false,
    );

    return TextButton(
      onPressed: isInFavorites
          ? null
          : () {
              var favStore = context.read<FavModel>();
              favStore.add(itemId!);
            },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.yellow;
          }
          return null; // Defer to the widget's default.
        }),
      ),
      child: isInFavorites
          ? Icon(Icons.check, color: Colors.yellow, semanticLabel: 'ADDED')
          : Text('ADD'),
    );
  }
}

class _MoviesItems extends StatelessWidget {
  final PagingController<int, Result> _pagingController =
      PagingController(firstPageKey: 0);

  _MoviesItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var movies = context.watch<MoviesModel>();

    if (!_pagingController.hasListeners) {
      _pagingController.addPageRequestListener((pageKey) {
        movies.incrementPage();
      });
    }

    _pagingController.itemList = <Result>[];
    if (movies.getMoviesStorage.total_pages == movies.getMoviesStorage.page) {
      _pagingController.appendLastPage(movies.getMoviesStorage.results);
    } else {
      _pagingController.appendPage(movies.getMoviesStorage.results, 0);
    }

    return PagedListView<int, Result>(
      key: new PageStorageKey('myListView'),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Result>(
        itemBuilder: (context, item, index) => Container(
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.black,
              border:
                  Border(bottom: BorderSide(color: Colors.white, width: 0.5))),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                        movieId: movies.getMoviesStorage.results[index].id,
                        backDropPath: movies.getMoviesStorage.results[index]
                                    .backdrop_path !=
                                null
                            ? movies
                                .getMoviesStorage.results[index].backdrop_path
                                .toString()
                            : ""),
                  ));
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 12),
                        child: Text(
                          '${movies.getMoviesStorage.results[index].title}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Image.network(
                      movies.getMoviesStorage.results[index].backdrop_path !=
                              null
                          ? 'https://image.tmdb.org/t/p/w300/${movies.getMoviesStorage.results[index].backdrop_path}'
                          : 'https://dummyimage.com/300x200/FFEB3B/000000.png&text=N/A',
                    ),
                    trailing: Container(
                      width: 50,
                      child: _AddButton(
                          itemId: movies.getMoviesStorage.results[index].id),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Vote: ${movies.getMoviesStorage.results[index].vote_average} / 10',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white),
                                    textWidthBasis: TextWidthBasis.longestLine,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8),
                                  child: Text(
                                    'Popularity: ${movies.getMoviesStorage.results[index].popularity.toInt()}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
