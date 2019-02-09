import 'package:movies_app/app/models/genre_model.dart';

class ResponseModel {
  int _page;
  int _totalResults;
  int _totalPages;
  List<MovieModel> _results = [];
  bool _isError = false;
  String _errorMessage = '';

  ResponseModel();

  ResponseModel.fromJson(Map<String, dynamic> json, List<GenreModel> genres) {
    _page = json['page'];
    _totalResults = json['total_results'];
    _totalPages = json['total_pages'];
    List<MovieModel> temp = [];
    for (int i = 0; i < json['results'].length; i++) {
      MovieModel result = MovieModel.fromJson(json['results'][i], genres);
      temp.add(result);
    }
    _results = temp;
  }

  List<MovieModel> get results => _results;

  set results(List<MovieModel> results) => _results = results;

  int get totalPages => _totalPages;

  int get totalResults => _totalResults;

  int get page => _page;

  bool get isError => _isError;
  set isError(bool isError) => _isError = isError;

  String get errorMessage => _errorMessage;
  set errorMessage(String errorMessage) => _errorMessage = errorMessage;
}

class MovieModel {
  final dynamic id;
  final dynamic voteCount;
  final bool video;
  final dynamic voteAverage;
  final String title;
  final dynamic popularity;
  final String posterPath;
  final String originalLanguage;
  final String originalTitle;
  final List<dynamic> genreIds;
  final String genres;
  final String backdropPath;
  final bool adult;
  final String overview;
  final String releaseDate;
  final dynamic spokenLanguages;
  final dynamic runtime;
  final String status;
  bool isFavourite;
  bool isError;
  String errorMessage;

  MovieModel({
    this.id,
    this.voteCount,
    this.voteAverage,
    this.video,
    this.title,
    this.popularity,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.genres,
    this.backdropPath,
    this.adult,
    this.overview,
    this.releaseDate,
    this.spokenLanguages,
    this.runtime,
    this.status,
    this.isFavourite = false,
    this.isError = false,
    this.errorMessage = ''
  });

  factory MovieModel.fromJson(Map<dynamic, dynamic> json, List<GenreModel> genres) {
    var genreNameList = [];
    if (genres != null) {
      var genreIds = json['genre_ids'];
      var findList = genres.where((GenreModel x) {
        return genreIds.indexOf(x.id) > -1;
      });
      findList.forEach((GenreModel z) {
        genreNameList.add(z.name);
      });
    }
    var runtime = json['runtime'] != null ? json['runtime'] : 0;
    var hours = 0;
    var minutes = 0.0;
    var time = (runtime / 60);
    hours = time.toInt();
    minutes = double.parse(time.toString().substring(0, 0) + '0' + time.toString().substring(1));
    minutes = minutes * 60;
    runtime = hours.toString() + 'h ' + minutes.toInt().toString() + 'm';
    return MovieModel(
        voteCount: json['vote_count'],
        id: json['id'],
        video: json['video'],
        voteAverage: json['vote_average'],
        title: json['title'],
        popularity: json['popularity'],
        posterPath: 'https://image.tmdb.org/t/p/w500' + json['poster_path'],
        originalLanguage: json['original_language'],
        originalTitle: json['original_title'],
        backdropPath: 'https://image.tmdb.org/t/p/w500' + json['backdrop_path'],
        adult: json['adult'],
        overview: json['overview'],
        releaseDate: json['release_date'],
        genreIds: json['genre_ids'],
        genres: (genreNameList.length > 0) ? genreNameList.join(' / ') : '',
        spokenLanguages: json['spoken_languages'] != null ? json['spoken_languages'] : null,
        runtime: runtime,
        status: json['status'] != null ? json['status'] : '',
        isFavourite: false
    );
  }
}