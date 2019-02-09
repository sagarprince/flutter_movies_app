import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';

// Models
import 'package:movies_app/app/models/movie_model.dart';
import 'package:movies_app/app/models/genre_model.dart';
import 'package:movies_app/app/models/trailers_model.dart';
import 'package:movies_app/app/models/credits_model.dart';
import 'package:movies_app/app/models/reviews_model.dart';

class ApiProvider {
  Client client = new Client();
  final _apiKey = '2ffe2cefa3ecef9f33e2603f6f63936d';
  final _baseUrl = 'http://api.themoviedb.org/3';

  List<dynamic> genres = <dynamic>[];

  Future<List<GenreModel>> fetchGenresList() async {
    try {
      final response = await client.get("$_baseUrl/genre/movie/list?api_key=$_apiKey");
      if (response.statusCode == 200) {
        var result = GenreResponseModel.fromJson(json.decode(response.body));
        return result.genres;
      } else {
        throw Exception('Failed to load genres');
      }
    } catch(e) {
      throw Exception('Something went wrong, please try again.');
    }
  }

  Future<ResponseModel> fetchMovieList() async {
    try {
      final genres = await fetchGenresList();
      final response = await client.get("$_baseUrl/movie/popular?api_key=$_apiKey");
      if (response.statusCode == 200) {
        return ResponseModel.fromJson(json.decode(response.body), genres);
      } else {
        throw Exception('Failed to load movies');
      }
    } catch(e) {
      print(e);
      throw Exception('Something went wrong, please try again.');
    }
  }

  Future<MovieModel> fetchMovieDetails(int movieId) async {
    try {
      final response = await client.get("$_baseUrl/movie/$movieId?api_key=$_apiKey");
      if (response.statusCode == 200) {
        return MovieModel.fromJson(json.decode(response.body), null);
      } else {
        throw Exception('Failed to movie details');
      }
    } catch(e) {
      print(e);
      throw Exception('Something went wrong, please try again');
    }
  }

  Future<CreditsResponseModel> fetchMovieCredits(int movieId) async {
    try {
      final response = await client.get("$_baseUrl/movie/$movieId/credits?api_key=$_apiKey");
      if (response.statusCode == 200) {
        return CreditsResponseModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load credits');
      }
    } catch(e) {
      throw Exception('Something went wrong, please try again');
    }
  }

  Future<TrailersResponseModel> fetchMovieTraliers(int movieId) async {
    try {
      final response = await client.get("$_baseUrl/movie/$movieId/videos?api_key=$_apiKey");
      if (response.statusCode == 200) {
        return TrailersResponseModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load trailers');
      }
    } catch(e) {
      throw Exception('Something went wrong, please try again.');
    }
  }

  Future<ReviewResponseModel> fetchMovieReviews(int movieId) async {
    try {
      final response = await client.get("$_baseUrl/movie/$movieId/reviews?api_key=$_apiKey");
      if (response.statusCode == 200) {
        return ReviewResponseModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch(e) {
      throw Exception('Something went wrong, please try again.');
    }
  }
}