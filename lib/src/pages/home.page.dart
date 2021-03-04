import 'package:flutter/material.dart';
import 'package:flutter_movie_jam/src/models/movie.model.dart';
import 'package:flutter_movie_jam/src/provider/movie.provider.dart';
import 'package:flutter_movie_jam/src/widgets/card_swiper.widget.dart';
import 'package:flutter_movie_jam/src/widgets/movie_horizontal.widget.dart';

import '../search_delegate.dart';

class HomePage extends StatelessWidget {
  final movies = new MovieProvider();

  @override
  Widget build(BuildContext context) {
    movies.getPopular();
    return Scaffold(
      appBar: AppBar(
        title: Text('New Movies!'),
        backgroundColor: Colors.black87,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: DataSearch()
              );
            },
          )
        ],
      ),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _swiperCards(),
          _footer(context),
        ],
      )),
    );
  }

  Widget _swiperCards() {
    return FutureBuilder(
      future: movies.getNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          return CardSwiperWidget(movies: snapshot.data);
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Popular',
                  style: Theme.of(context).textTheme.subtitle1)),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: movies.popularStream,
            builder:
                (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  movies: snapshot.data,
                  nextPage: movies.getPopular,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }
}
