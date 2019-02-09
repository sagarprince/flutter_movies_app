// Core
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Theme
import 'package:movies_app/app/theme.dart';

class MovieMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String profilePic;

  MovieMemberCard({Key key, this.name, this.role = '', this.profilePic = ''}) :
      assert(name != null),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(left: 6.0, right: 6.0),
      child: new Column(
        children: <Widget>[
          new Material(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            clipBehavior: Clip.hardEdge,
            child: new CachedNetworkImage(
              placeholder: new Container(
                  width: 60,
                  height: 60,
                  child: new Center(
                    child:  new CircularProgressIndicator(
                      strokeWidth: 3.0,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    ),
                  )
              ),
              width: 60,
              height: 60,
              imageUrl: profilePic != '' ? profilePic : 'https://soe.ukzn.ac.za/wp-content/uploads/2018/04/profile-placeholder.png',
              fit: BoxFit.cover,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(top: 10.0),
            width: 90.0,
            child: new Text(name, textAlign: TextAlign.center, style: new TextStyle(fontSize: 15.0)),
          ),
        ],
      ),
    );
  }
}