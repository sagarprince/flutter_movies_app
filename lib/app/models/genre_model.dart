class GenreResponseModel {
  List<GenreModel> _genres;

  GenreResponseModel();

  GenreResponseModel.fromJson(Map<dynamic, dynamic> json) {
    List<GenreModel> temp = [];
    for (int i = 0; i < json['genres'].length; i++) {
      GenreModel result = GenreModel.fromJson(json['genres'][i]);
      temp.add(result);
    }
    _genres = temp;
  }

  List<GenreModel> get genres => _genres;
}

class GenreModel {
  final int id;
  final String name;

  GenreModel({
    this.id,
    this.name,
  });

  factory GenreModel.fromJson(Map<dynamic, dynamic> json) {
    return GenreModel(
        id: json['id'],
        name: json['name']
    );
  }
}