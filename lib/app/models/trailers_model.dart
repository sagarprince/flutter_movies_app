class TrailersResponseModel {
  List<TrailersModel> _results = [];
  bool _isError = false;
  String _errorMessage = '';

  TrailersResponseModel();

  TrailersResponseModel.fromJson(Map<String, dynamic> json) {
    List<TrailersModel> temp = [];
    for (int i = 0; i < json['results'].length; i++) {
      TrailersModel result = TrailersModel.fromJson(json['results'][i]);
      temp.add(result);
    }
    _results = temp;
  }

  set results(List<TrailersModel> results) => _results = results;
  List<TrailersModel> get results => _results;

  bool get isError => _isError;
  set isError(bool isError) => _isError = isError;

  String get errorMessage => _errorMessage;
  set errorMessage(String errorMessage) => _errorMessage = errorMessage;
}

class TrailersModel {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  String thumbnail;

  TrailersModel({
    this.id,
    this.key,
    this.name,
    this.site,
    this.type,
    this.thumbnail = ''
  });

  factory TrailersModel.fromJson(Map<dynamic, dynamic> json) {
    return TrailersModel(
        id: json['id'],
        key: json['key'],
        name: json['name'],
        site: json['site'],
        type: json['type'],
        thumbnail: json['site'].toString().toLowerCase() == 'youtube' ? 'http://img.youtube.com/vi/'+json['key']+'/hqdefault.jpg' : '',
    );
  }
}
