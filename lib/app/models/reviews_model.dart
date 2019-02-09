import 'package:movies_app/app/models/genre_model.dart';

class ReviewResponseModel {
  int _page;
  int _totalResults;
  int _totalPages;
  List<ReviewModel> _results = [];
  bool _isError = false;
  String _errorMessage = '';

  ReviewResponseModel();

  ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    _page = json['page'];
    _totalResults = json['total_results'];
    _totalPages = json['total_pages'];
    List<ReviewModel> temp = [];
    for (int i = 0; i < json['results'].length; i++) {
      ReviewModel result = ReviewModel.fromJson(json['results'][i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<ReviewModel> get results => _results;

  set results(List<ReviewModel> results) => _results = results;

  int get totalPages => _totalPages;

  int get totalResults => _totalResults;

  int get page => _page;

  bool get isError => _isError;
  set isError(bool isError) => _isError = isError;

  String get errorMessage => _errorMessage;
  set errorMessage(String errorMessage) => _errorMessage = errorMessage;
}

class ReviewModel {
  final dynamic id;
  final dynamic author;
  final dynamic content;

  ReviewModel({
    this.id,
    this.author,
    this.content
  });

  factory ReviewModel.fromJson(Map<dynamic, dynamic> json) {
    return ReviewModel(
        id: json['id'],
        author: json['author'],
        content: json['content']
    );
  }
}