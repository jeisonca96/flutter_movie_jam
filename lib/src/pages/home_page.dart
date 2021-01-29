import 'package:flutter/material.dart';
import 'package:flutter_movie_jam/src/models/movie.dart';
import 'package:flutter_movie_jam/src/provider/movie.provider.dart';
import 'package:flutter_movie_jam/src/widgets/card_swiper.widget.dart';

class HomePage extends StatelessWidget {
  final movies = new MovieProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Movies'),
        backgroundColor: Colors.black87,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
          child: Column(
        children: <Widget>[_swiperCards()],
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
}
