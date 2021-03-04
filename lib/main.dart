import 'package:flutter/material.dart';
import 'package:flutter_movie_jam/src/pages/home.page.dart';
import 'package:flutter_movie_jam/src/pages/movie_detail.page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies Jam',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detail': (BuildContext context) => MovieDetail(),
      },
    );
  }
}
