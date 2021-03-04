import 'package:flutter/material.dart';
import 'package:flutter_movie_jam/src/provider/movie.provider.dart';

import 'models/movie.model.dart';

class DataSearch extends SearchDelegate {
  final recentMovies = [''];
  final movies = [''];

  String selection = '';
  final movieProvider = new MovieProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones del AppBar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Resultados a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
        future: movieProvider.searchMovie(query),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasData) {
            final movies = snapshot.data;
            return ListView(
                children: movies.map((movie) {
                  return ListTile(
                    leading: FadeInImage(
                      image: NetworkImage(movie.getPosterImage()),
                      placeholder: AssetImage('assets/img/no-image.jpg'),
                      width: 50.0,
                      fit: BoxFit.cover,
                    ),
                    title: Text(movie.title),
                    subtitle: Text(movie.originalTitle),
                    onTap: () {
                      movie.uniqueId = '';
                      close(context, null);
                      Navigator.pushNamed(context, 'detail', arguments: movie);
                    },
                  );
                }).toList()
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

/*
  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias
    final suggestedList = (query.isEmpty) ? recentMovies : movies.where((p) =>
        p.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
        itemCount: suggestedList.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Icon(Icons.movie),
            title: Text(suggestedList[i]),
            onTap: () {
              selection = suggestedList[i];
              showResults(context);
            },
          );
        });
  }
 */
}
