import 'dart:async';
import 'package:rxdart/rxdart.dart';

// Models
import 'package:movies_app/app/models/movie_model.dart';
import 'package:movies_app/app/models/credits_model.dart';
import 'package:movies_app/app/models/trailers_model.dart';
import 'package:movies_app/app/models/reviews_model.dart';

// Repository
import 'package:movies_app/app/resources/repository.dart';

class MoviesBloc {
  final _repository = new Repository();

  final _movieSearchSubject = new PublishSubject<dynamic>();
  final _moviePublishSubject = new PublishSubject<ResponseModel>();
  final _movieDetailsPublishSubject = new PublishSubject<MovieModel>();
  final _movieCreditsPublishSubject = new PublishSubject<CreditsResponseModel>();
  final _trailersMovieSubject = new PublishSubject<TrailersResponseModel>();
  final _reviewsMovieSubject = new PublishSubject<ReviewResponseModel>();

  Observable<dynamic> get movieSearchStream => _movieSearchSubject.stream;
  Observable<ResponseModel> get moviesStream => _moviePublishSubject.stream;
  Observable<MovieModel> get moviesDetailsStream => _movieDetailsPublishSubject.stream;
  Observable<CreditsResponseModel> get movieCreditsStream => _movieCreditsPublishSubject.stream;
  Observable<TrailersResponseModel> get movieTrailersStream => _trailersMovieSubject.stream;
  Observable<ReviewResponseModel> get movieReviewStream => _reviewsMovieSubject.stream;

  fetchMovies() async {
    ResponseModel responseModel = await _repository.fetchMovies();
    _moviePublishSubject.sink.add(responseModel);
  }

  searchMovies(String search) async {
    _movieSearchSubject.sink.add(search);
  }

  fetchMovieDetails(int movieId) async {
    MovieModel movieDetailsModel = await _repository.fetchMovieDeails(movieId);
    _movieDetailsPublishSubject.sink.add(movieDetailsModel);
  }

  fetchCredits(int movieId) async {
    CreditsResponseModel creditsResponseModel = await _repository.fetchCredits(movieId);
    _movieCreditsPublishSubject.sink.add(creditsResponseModel);
  }

  fetchTrailers(int movieId) async {
    TrailersResponseModel responseModel = await _repository.fetchTrailers(movieId);
    _trailersMovieSubject.sink.add(responseModel);
  }

  fetchReviews(int movieId) async {
    ReviewResponseModel responseModel = await _repository.fetchReviews(movieId);
    _reviewsMovieSubject.sink.add(responseModel);
  }

  dispose() {
    _moviePublishSubject.close();
    _movieDetailsPublishSubject.close();
    _trailersMovieSubject.close();
    _reviewsMovieSubject.close();
  }
}

final bloc = new MoviesBloc();