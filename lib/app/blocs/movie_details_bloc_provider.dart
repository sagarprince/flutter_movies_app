import 'package:flutter/material.dart';

// Models
import 'package:movies_app/app/models/movie_model.dart';
import 'package:movies_app/app/models/credits_model.dart';
import 'package:movies_app/app/models/trailers_model.dart';
import 'package:movies_app/app/models/reviews_model.dart';

// Bloc Base
import 'package:movies_app/app/blocs/movies_bloc.dart';

class _MovieDetailsBlocProvider extends InheritedWidget {
  _MovieDetailsBlocProvider({
    Key key,
    @required Widget child,
    @required this.data
  }) : super(key: key, child: child);

  final MovieDetailsBlocWidgetState data;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class MovieDetailsBlocWidget extends StatefulWidget {
  final MovieModel movie;
  final Widget child;

  MovieDetailsBlocWidget({
    Key key,
    @required this.movie,
    @required this.child
  }): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MovieDetailsBlocWidgetState();
  }

  static MovieDetailsBlocWidgetState of([BuildContext context, bool rebuild = true]) {
    return (rebuild ? context.inheritFromWidgetOfExactType(_MovieDetailsBlocProvider) as _MovieDetailsBlocProvider
        : context.ancestorWidgetOfExactType(_MovieDetailsBlocProvider) as _MovieDetailsBlocProvider).data;
  }
}

class MovieDetailsBlocWidgetState extends State<MovieDetailsBlocWidget> {
  final MoviesBloc bloc = new MoviesBloc();

  bool _isMovieDetailsLoading = true;
  MovieModel _movieDetails;
  bool _isMovieDetailsError = false;
  String _movieDetailsErrorMessage = '';

  bool _isMovieCreditsLoading = true;
  List<CastModel> _casts = [];
  List<CrewModel> _crew = [];
  bool _isMovieCreditsError = false;
  String _movieCreditsErrorMessage = '';

  bool _isMovieTrailersLoading = true;
  List<TrailersModel> _trailers = [];
  bool _isMovieTrailersError = false;
  String _movieTrailersErrorMessage = '';

  bool _isMovieReviewsLoading = true;
  List<ReviewModel> _reviews = [];
  bool _isMovieReviewsError = false;
  String _movieReviewsErrorMessage = '';

  bool get isMovieDetailsLoading => _isMovieDetailsLoading;
  MovieModel get movieDetails => _movieDetails;
  bool get isMovieDetailsError => _isMovieDetailsError;
  String get movieDetailsErrorMessage => _movieDetailsErrorMessage;

  bool get isMovieCreditsLoading => _isMovieCreditsLoading;
  List<CastModel> get casts => _casts;
  List<CrewModel> get crew => _crew;
  bool get isMovieCreditsError => _isMovieCreditsError;
  String get movieCreditsErrorMessage => _movieCreditsErrorMessage;

  bool get isMovieTrailersLoading => _isMovieTrailersLoading;
  List<TrailersModel> get trailers => _trailers;
  bool get isMovieTrailersError => _isMovieTrailersError;
  String get movieTrailersErrorMessage => _movieTrailersErrorMessage;

  bool get isMovieReviewsLoading => _isMovieReviewsLoading;
  List<ReviewModel> get reviews => _reviews;
  bool get isMovieReviewsError => _isMovieReviewsError;
  String get movieReviewsErrorMessage => _movieReviewsErrorMessage;


  @override
  void initState() {
    super.initState();
    bloc.fetchMovieDetails(widget.movie.id);
    bloc.fetchCredits(widget.movie.id);
    bloc.fetchTrailers(widget.movie.id);
    bloc.fetchReviews(widget.movie.id);

    bloc.moviesDetailsStream.listen((MovieModel response) {
      setState(() {
        _movieDetails = response;
        _isMovieDetailsLoading = false;
        _isMovieDetailsError = response.isError;
        _movieDetailsErrorMessage = response.errorMessage;
      });
    });

    bloc.movieCreditsStream.listen((CreditsResponseModel response) {
      setState(() {
        _casts = response.casts;
        _crew = response.crew;
        _isMovieCreditsLoading = false;
        _isMovieCreditsError = response.isError;
        _movieCreditsErrorMessage = response.errorMessage;
      });
    });

    bloc.movieTrailersStream.listen((TrailersResponseModel response) {
      setState(() {
        _trailers = response.results;
        _isMovieTrailersLoading = false;
        _isMovieTrailersError = response.isError;
        _movieTrailersErrorMessage = response.errorMessage;
      });
    });

    bloc.movieReviewStream.listen((ReviewResponseModel response) {
      setState(() {
        _reviews = response.results;
        _isMovieReviewsLoading = false;
        _isMovieReviewsError = response.isError;
        _movieReviewsErrorMessage = response.errorMessage;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return new _MovieDetailsBlocProvider(
        child: widget.child,
        data: this
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}