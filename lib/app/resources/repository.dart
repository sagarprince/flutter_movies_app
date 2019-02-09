import 'dart:async';
import 'package:movies_app/app/resources/api_provider.dart';

// Models
import 'package:movies_app/app/models/movie_model.dart';
import 'package:movies_app/app/models/credits_model.dart';
import 'package:movies_app/app/models/trailers_model.dart';
import 'package:movies_app/app/models/reviews_model.dart';

class Repository {
  final apiProvider = new ApiProvider();
  ResponseModel responseModel = new ResponseModel();
  MovieModel movieDetailsModel = new MovieModel();
  CreditsResponseModel creditsResponseModel = new CreditsResponseModel();
  TrailersResponseModel trailersModel = new TrailersResponseModel();
  ReviewResponseModel reviewsModel = new ReviewResponseModel();

  Future<ResponseModel> fetchMovies() {
    responseModel.isError = false;
    responseModel.errorMessage = '';
    return apiProvider.fetchMovieList().then((ResponseModel response) {
        return response;
      }).catchError((e) {
        responseModel.isError = true;
        responseModel.errorMessage = e.toString();
        responseModel.results = [];
        return responseModel;
      });
  }

  Future<MovieModel> fetchMovieDeails(int movieId) {
    movieDetailsModel.isError = false;
    movieDetailsModel.errorMessage = '';
    return apiProvider.fetchMovieDetails(movieId).then((MovieModel response) {
      return response;
    }).catchError((e) {
      print(e);
      movieDetailsModel.isError = true;
      movieDetailsModel.errorMessage = e.toString();
      return movieDetailsModel;
    });
  }

  Future<CreditsResponseModel> fetchCredits(int movieId) {
    creditsResponseModel.isError = false;
    creditsResponseModel.errorMessage = '';
    return apiProvider.fetchMovieCredits(movieId).then((CreditsResponseModel response) {
      return response;
    }).catchError((e) {
      creditsResponseModel.isError = true;
      creditsResponseModel.errorMessage = e.toString();
      creditsResponseModel.casts = [];
      creditsResponseModel.crew = [];
      return creditsResponseModel;
    });
  }

  Future<TrailersResponseModel> fetchTrailers(int movieId) {
    trailersModel.isError = false;
    trailersModel.errorMessage = '';
    return apiProvider.fetchMovieTraliers(movieId).then((TrailersResponseModel response) {
      return response;
    }).catchError((e) {
      trailersModel.isError = true;
      trailersModel.errorMessage = e.toString();
      trailersModel.results = [];
      return trailersModel;
    });
  }

  Future<ReviewResponseModel> fetchReviews(int movieId) {
    reviewsModel.isError = false;
    reviewsModel.errorMessage = '';
    return apiProvider.fetchMovieReviews(movieId).then((ReviewResponseModel response) {
      return response;
    }).catchError((e) {
      reviewsModel.isError = true;
      reviewsModel.errorMessage = e.toString();
      reviewsModel.results = [];
      return reviewsModel;
    });
  }

}
