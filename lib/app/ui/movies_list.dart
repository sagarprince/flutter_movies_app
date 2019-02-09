// Core
import 'package:flutter/material.dart';

// Theme
import 'package:movies_app/app/theme.dart';

// Bloc Provider
import 'package:movies_app/app/blocs/movies_bloc_provider.dart';

// UI Widgets
import 'package:movies_app/app/ui/widgets/movies_card_flipper.dart';

class MoviesList extends StatefulWidget {
  MoviesList();

  @override
  State<StatefulWidget> createState() {
    return _MoviesListState();
  }
}

class _MoviesListState extends State<MoviesList> {
  MoviesBlocWidgetState blocState;

  @override
  void initState() {
    super.initState();
  }

  Widget _loader() {
    return new Center(
      child:  new CircularProgressIndicator(
        strokeWidth: 3.0,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      ),
    );
  }

  Widget _message(String message, [Color color = Colors.redAccent]) {
    return new Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: new Center(
        child: new Text(message, textAlign: TextAlign.center, style: new TextStyle(fontSize: 20.0, color: color)),
      ),
    );
  }

  Widget _moviesScrollList(MoviesBlocWidgetState blocState) {
    return (blocState.movies.length > 0) ? new MoviesCardFlipper(
        movies: blocState.movies
    ) : _message('No Movies Found');
  }

  Widget _moviesList(MoviesBlocWidgetState blocState) {
    return (!blocState.isError) ? _moviesScrollList(blocState) : _message(blocState.errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    blocState = MoviesBlocWidget.of(context);
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    final double topPadding = statusbarHeight + 105;

    return new Container(
      alignment: Alignment.topCenter,
      padding: new EdgeInsets.only(top: topPadding, left: 0.0, right: 0.0, bottom: 35.0),
      child: blocState.isLoading ? _loader() : _moviesList(blocState),
    );
  }

  @override
  void dispose() {
    super.dispose();
    blocState.dispose();
  }
}