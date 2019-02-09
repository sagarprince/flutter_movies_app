import 'package:flutter/material.dart';
import 'package:movies_app/app/models/movie_model.dart';
import 'package:movies_app/app/blocs/movies_bloc.dart';

class _MoviesBlocProvider extends InheritedWidget {
  _MoviesBlocProvider({
    Key key,
    @required Widget child,
    @required this.data
  }) : super(key: key, child: child);


  final MoviesBlocWidgetState data;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class MoviesBlocWidget extends StatefulWidget {
  MoviesBlocWidget({
    Key key,
    @required this.child
  }) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() {
    return MoviesBlocWidgetState();
  }

  static MoviesBlocWidgetState of([BuildContext context, bool rebuild = true]) {
    return (rebuild ? context.inheritFromWidgetOfExactType(_MoviesBlocProvider) as _MoviesBlocProvider
        : context.ancestorWidgetOfExactType(_MoviesBlocProvider) as _MoviesBlocProvider).data;
  }
}

class MoviesBlocWidgetState extends State<MoviesBlocWidget> {
  final MoviesBloc bloc = new MoviesBloc();

  List<MovieModel> _movies = <MovieModel>[];
  List<MovieModel> _allMovies = <MovieModel>[];
  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = '';

  List<MovieModel> _favourites = [];

  @override
  void initState() {
    super.initState();
    bloc.fetchMovies();
    bloc.moviesStream.listen((ResponseModel response) {
      setState(() {
        _movies = response.results;
        _allMovies = response.results;
        _isLoading = false;
        _isError = response.isError;
        _errorMessage = response.errorMessage;
      });
    });
    bloc.movieSearchStream.listen((dynamic s) {
      setState(() {
        if (s.trim() != '') {
          _movies = _allMovies
              .where((x) => x.title.toLowerCase().indexOf(s) > -1)
              .toList();
        } else {
          _movies = _allMovies;
        }
      });
    });
  }

  List<MovieModel> get movies => _movies;

  bool get isLoading => _isLoading;

  bool get isError => _isError;

  String get errorMessage => _errorMessage;

  List<MovieModel> get favourites => _favourites;

  void addToFavourites(MovieModel movie) {
    setState(() {
      _favourites.add(movie);
    });
  }

  void removeFromFavourites(MovieModel movie) {
    setState(() {
      _favourites.removeWhere((MovieModel x) {
        return x.id == movie.id;
      });
    });
  }

  void searchMovies(String search) {
    bloc.searchMovies(search);
  }

  @override
  Widget build(BuildContext context) {
    return new _MoviesBlocProvider(
        child: widget.child,
        data: this
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }
}