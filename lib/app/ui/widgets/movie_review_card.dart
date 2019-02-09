// Core
import 'package:flutter/material.dart';

// Theme
import 'package:movies_app/app/theme.dart';

class MovieReviewCard extends StatelessWidget {
  final String author;
  final String content;

  MovieReviewCard({Key key, this.author, this.content}) :
        assert(author != null),
        assert(content != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(
                child: new Text(author!= null ? author[0].toUpperCase() : 'U')
            ),
          ),
          new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(author, style: Theme.of(context).textTheme.subhead),
                  new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(content)
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}