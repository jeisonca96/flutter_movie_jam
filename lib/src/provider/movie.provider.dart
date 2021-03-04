import 'dart:async';
import 'dart:convert';

import 'package:flutter_movie_jam/src/models/actor.model.dart';
import 'package:flutter_movie_jam/src/models/movie.model.dart';
import 'package:http/http.dart' as http;

class MovieProvider {
  String _apiKey = 'd9954db29c4cd952cce52b6c903a410c';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularPage = 0;
  bool _loadPopular = false;

  List<Movie> _popular = new List();

  final _popularStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularSink => _popularStreamController.sink.add;

  Stream<List<Movie>> get popularStream => _popularStreamController.stream;

  void disposeStreams() {
    _popularStreamController?.close();
  }

  Future<List<Movie>> _responseProcess(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body)['results'];
    final movies = new Movies.fromJsonList(decodedData);

    return movies.items;
  }

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});

    return await _responseProcess(url);
  }

  Future<List<Movie>> getPopular() async {
    if (_loadPopular) return [];

    _loadPopular = true;
    _popularPage++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularPage.toString()
    });

    final response = await _responseProcess(url);
    _popular.addAll(response);
    popularSink(_popular);

    _loadPopular = false;

    return _popular;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    return await _responseProcess(url);
  }

  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits',
        {'api_key': _apiKey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body)['cast'];
    final cast = new Cast.fromJsonList(decodedData);

    return cast.actors;
  }
}
