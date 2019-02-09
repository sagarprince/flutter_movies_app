// Core
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

// Theme
import 'package:movies_app/app/theme.dart';

class MovieTrailerCard extends StatelessWidget {
  final String videoId;
  final String name;
  final String thumbnail;

  MovieTrailerCard({Key key, this.videoId, this.name, this.thumbnail = ''}) :
        assert(videoId != null),
        super(key: key);

  _playVideo() {
    FlutterYoutube.playYoutubeVideoById(
        apiKey: "AIzaSyC1RxZXb5F3eqqB0RcXGsDd5xbLAN8Mz9A",
        videoId: videoId,
        autoPlay: true, //default falase
        fullScreen: false //default false
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(left: 6.0, right: 6.0),
      child: new Column(
        children: <Widget>[
          new GestureDetector(
            child: new Stack(
              children: <Widget>[
                new Material(
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  clipBehavior: Clip.hardEdge,
                  child: new CachedNetworkImage(
                    placeholder: new Container(
                        width: 140,
                        height: 140,
                        child: new Center(
                          child:  new CircularProgressIndicator(
                            strokeWidth: 3.0,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                          ),
                        )
                    ),
                    width: 140,
                    height: 140,
                    imageUrl: thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
                new Positioned(
                  top: 0,
                  left: 0,
                  child: new Container(
                    width: 140,
                    height: 140,
                    decoration: new BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.2)
                    ),
                    child: new Icon(Icons.play_circle_outline, color: Colors.deepOrange, size: 60),
                  ),
                )
              ],
            ),
            onTap: _playVideo,
          )
        ],
      ),
    );
  }
}