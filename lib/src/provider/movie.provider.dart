import 'dart:convert';

import 'package:flutter_movie_jam/src/models/movie.dart';
import 'package:http/http.dart' as http;

class MovieProvider {
  String _apiKey = 'd9954db29c4cd952cce52b6c903a410c';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body)['results'];

    final movies = new Movies.fromJsonList(decodedData);

    return movies.items;
  }
}
