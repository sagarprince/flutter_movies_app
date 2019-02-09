class CreditsResponseModel {
  List<CastModel> _casts = [];
  List<CrewModel> _crew = [];
  bool _isError = false;
  String _errorMessage = '';

  CreditsResponseModel();

  CreditsResponseModel.fromJson(Map<String, dynamic> json) {
    List<CastModel> castTemp = [];
    List<CrewModel> crewTemp = [];

    if (json['cast'] != null && json['cast'].length > 0) {
      for (int i = 0; i < json['cast'].length; i++) {
        CastModel result = CastModel.fromJson(json['cast'][i]);
        castTemp.add(result);
      }
    }

    if (json['crew'] != null && json['crew'].length > 0) {
      for (int i = 0; i < json['crew'].length; i++) {
        CrewModel result = CrewModel.fromJson(json['crew'][i]);
        crewTemp.add(result);
      }
    }

    _casts = castTemp;
    _crew = crewTemp;
  }

  set casts(List<CastModel> casts) => _casts = casts;
  List<CastModel> get casts => _casts;

  set crew(List<CrewModel> crew) => _crew = crew;
  List<CrewModel> get crew => _crew;

  set isError(bool isError) => _isError = isError;
  bool get isError => _isError;

  set errorMessage(String message) => _errorMessage = message;
  String get errorMessage => _errorMessage;
}

class CastModel {
  final int id;
  final int castId;
  final int order;
  final String name;
  final String character;
  final String profilePath;

  CastModel({
    this.id,
    this.castId,
    this.order,
    this.name,
    this.character,
    this.profilePath
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: json['id'],
      castId: json['cast_id'],
      order: json['order'],
      name: json['name'],
      character: json['character'],
      profilePath: json['profile_path'] != null ? 'https://image.tmdb.org/t/p/w200' + json['profile_path'] : ''
    );
  }
}

class CrewModel {
  final int id;
  final String department;
  final String job;
  final String name;
  final String profilePath;

  CrewModel({
    this.id,
    this.job,
    this.department,
    this.name,
    this.profilePath
  });

  factory CrewModel.fromJson(Map<String, dynamic> json) {
    return CrewModel(
        id: json['id'],
        job: json['job'],
        department: json['department'],
        name: json['name'],
        profilePath: json['profile_path'] != null ? 'https://image.tmdb.org/t/p/w200' + json['profile_path'] : ''
    );
  }
}