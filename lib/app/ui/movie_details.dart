// Core
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Theme
import 'package:movies_app/app/theme.dart';

// Models
import 'package:movies_app/app/models/movie_model.dart';
import 'package:movies_app/app/models/credits_model.dart';
import 'package:movies_app/app/models/trailers_model.dart';
import 'package:movies_app/app/models/reviews_model.dart';

// Bloc Provider
import 'package:movies_app/app/blocs/movie_details_bloc_provider.dart';

// Widgets
import 'package:movies_app/app/ui/widgets/movie_member_card.dart';
import 'package:movies_app/app/ui/widgets/movie_trailer_card.dart';
import 'package:movies_app/app/ui/widgets/movie_review_card.dart';

class MovieDetails extends StatefulWidget {
  final MovieModel movie;
  final bool isShowTrailers;

  MovieDetails({Key key, @required this.movie, this.isShowTrailers = false}) :
      assert(movie != null),
      super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MovieDetailsState();
  }
}

class MovieDetailsState extends State<MovieDetails> {
  GlobalKey _keyTrailers = new GlobalKey();
  MovieDetailsBlocWidgetState movieDetailsBlocState;
  ScrollController _scrollController;
  bool lastStatus = true;
  double appBarHeight = 0.0;
  bool isScrollToTrailers = false;
  double trailersYOffset = 0;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (appBarHeight - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    _getPositions();
    _scrollToTrailers();
  }

  _getPositions() {
    final RenderBox renderTrailersBox = _keyTrailers.currentContext.findRenderObject();
    final trailersPositions = renderTrailersBox.localToGlobal(Offset.zero);
    trailersYOffset = trailersPositions.dy.floorToDouble();
  }

  _scrollToTrailers() {
    if (mounted && _scrollController.hasClients && !isScrollToTrailers && widget.isShowTrailers) {
      _scrollController.animateTo(trailersYOffset - 70, duration: new Duration(milliseconds: 1000), curve: Curves.easeIn).then((data) {
        isScrollToTrailers = true;
      });
    }
  }

  Widget _infoLoader() {
    return new Container(
      child: new Text('Loading...'),
    );
  }

  Widget _movieGenres() {
    var genres = widget.movie.genres.split(new RegExp(r'/'));
    List<Widget> genreWidgets = [];
    if (genres.length > 0) {
      genres.forEach((genre) {
        genreWidgets.add(
          new Container(
            margin: EdgeInsets.only(right: 8.0, bottom: 10.0),
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0, bottom: 6.0),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
                style: BorderStyle.solid
              )
            ),
            child: new Text(genre.toUpperCase(), textAlign: TextAlign.center, style: new TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.teal)),
          )
        );
      });
    }

    return new Container(
      child: new Wrap(
        spacing: 0.0,
        runSpacing: 0.0,
        alignment: WrapAlignment.start,
        children: genreWidgets,
      ),
    );
  }

  Widget _movieVoteAverage() {
    var voteAverage = widget.movie.voteAverage;
    return new Container(
      margin: EdgeInsets.only(top: 6.0),
      width: 45,
      height: 28,
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
        color: voteAverage > 5.5 ? Colors.green : Colors.deepOrangeAccent
      ),
      child: new Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
              voteAverage.toString(),
              textAlign: TextAlign.center,
              style: new TextStyle(fontSize: 18.0, color: AppColors.whiteColor)
          ),
        ],
      )
    );
  }

  Widget _movieLanguage() {
    var spokenLanguages = movieDetailsBlocState.movieDetails != null ? movieDetailsBlocState.movieDetails.spokenLanguages : [];
    List<String> languages = [];
    if (spokenLanguages.length > 0) {
        spokenLanguages.forEach((x) {
          languages.add(x['name']);
        });
    }
    return new Container(
        margin: EdgeInsets.only(top: 10.0),
        child: new Wrap(
          runSpacing: 2.0,
          alignment: WrapAlignment.start,
          children: [
            new Text('Languages: ', style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            !movieDetailsBlocState.isMovieDetailsLoading ?
            new Text(languages.length > 0 ? languages.join(', ') : '-', style: new TextStyle(fontSize: 16.0)) : _infoLoader()
          ],
        ),
    );
  }

  Widget _movieRunningTime() {
    var runtime = movieDetailsBlocState.movieDetails != null ? movieDetailsBlocState.movieDetails.runtime.toString() : '';
    return new Container(
      margin: EdgeInsets.only(top: 10.0),
      child: new Wrap(
        children: <Widget>[
          new Text('Running Time: ', style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          !movieDetailsBlocState.isMovieDetailsLoading ?
          new Text(runtime, style: new TextStyle(fontSize: 16.0)) : _infoLoader()
        ],
      ),
    );
  }

  Widget _movieStatus() {
    var status = movieDetailsBlocState.movieDetails != null ? movieDetailsBlocState.movieDetails.status : '';
    return new Container(
      margin: EdgeInsets.only(top: 10.0),
      child: new Wrap(
        children: <Widget>[
          new Text('Status: ', style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          !movieDetailsBlocState.isMovieDetailsLoading ?
          new Text(status, style: new TextStyle(fontSize: 16.0)) : _infoLoader()
        ],
      ),
    );
  }

  Widget _movieReleaseDate() {
    var releaseDate = movieDetailsBlocState.movieDetails != null ? movieDetailsBlocState.movieDetails.releaseDate : '';
    return new Container(
      margin: EdgeInsets.only(top: 10.0),
      child: new Wrap(
        children: <Widget>[
          new Text('Release Date: ', style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          !movieDetailsBlocState.isMovieDetailsLoading ?
          new Text(releaseDate, style: new TextStyle(fontSize: 16.0)) : _infoLoader()
        ],
      ),
    );
  }

  Widget _moviePosterDetails() {
    return new Container(
      padding: EdgeInsets.only(top: 20.0, left: 15.0 , right: 15.0, bottom: 20.0),
      decoration: new BoxDecoration(
        color: Color.fromRGBO(221, 221, 221, 0.6)
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Hero(
            tag: widget.movie.id.toString(),
            child: new Material(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              clipBehavior: Clip.hardEdge,
              child: new CachedNetworkImage(
                placeholder: new Container(
                    width: 150,
                    height: 200,
                    child: new Center(
                      child:  new CircularProgressIndicator(
                        strokeWidth: 3.0,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                      ),
                    )
                ),
                width: 150,
                height: 200,
                imageUrl: widget.movie.posterPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          new Expanded(
            child: new Container(
              margin: EdgeInsets.only(left: 30.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _movieGenres(),
                  _movieVoteAverage(),
                  _movieLanguage(),
                  _movieRunningTime(),
                  _movieStatus(),
                  _movieReleaseDate()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _movieOverview() {
    return new Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: new Text(
                'Overview',
                style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
            ),
          ),
          new Text(
              widget.movie.overview,
              style: new TextStyle(fontSize: 16.0)
          )
        ],
      ),
    );
  }

  Widget _movieCasts() {
    List<CastModel> casts = movieDetailsBlocState.casts != null ? movieDetailsBlocState.casts : [];
    return new Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(top: 20.0),
      decoration: new BoxDecoration(
          color: Color.fromRGBO(221, 221, 221, 0.6)
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
            child: new Text(
                'Cast',
                style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
            ),
          ),
          new Container(
            height: 145.0,
            child: ListView.builder(
              itemCount: casts.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return new MovieMemberCard(
                  name: casts[index].name,
                  role: casts[index].character,
                  profilePic: casts[index].profilePath,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _movieCrew() {
    List<CrewModel> crew = movieDetailsBlocState.crew != null ? movieDetailsBlocState.crew : [];
    return new Container(
      margin: EdgeInsets.only(top: 15.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
            child: new Text(
                'Crew',
                style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
            ),
          ),
          new Container(
            height: 145.0,
            child: ListView.builder(
              itemCount: crew.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return new MovieMemberCard(
                  name: crew[index].name,
                  role: crew[index].department,
                  profilePic: crew[index].profilePath,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _movieTrailers() {
    List<TrailersModel> trailers = movieDetailsBlocState.trailers != null ? movieDetailsBlocState.trailers : [];
    return new Container(
      key: _keyTrailers,
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
      decoration: new BoxDecoration(
        color: Color.fromRGBO(40, 90, 90, 1)
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
            child: new Text(
                'Trailers',
                style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: AppColors.whiteColor)
            ),
          ),
          new Container(
            height: 150.0,
            child: ListView.builder(
              itemCount: trailers.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return new MovieTrailerCard(
                  videoId: trailers[index].key,
                  name: trailers[index].name,
                  thumbnail: trailers[index].thumbnail,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _getMovieReviews(List<ReviewModel> reviews) {
    List<Widget> reviewWidgets = [];
    if (reviews.length > 0) {
      reviews.forEach((review) {
        reviewWidgets.add(
            new MovieReviewCard(author: review.author, content: review.content)
        );
      });
    }
    return reviewWidgets;
  }

  Widget _movieReviews() {
    List<ReviewModel> reviews = movieDetailsBlocState.reviews != null ? movieDetailsBlocState.reviews : [];
    var count = reviews.length;
    return new Container(
      margin: EdgeInsets.only(top: 15.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
            child: new Text(
                'Reviews ('+count.toString()+')',
                style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
            ),
          ),
          new Container(
            child: count > 0 ? new Column(
              children: _getMovieReviews(reviews),
            ) :
            new Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
              child: new Text('No Reviews', style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
            ),
          )
        ],
      ),
    );
  }

  Widget _sliverAppBar() {
    final mediaQuery = MediaQuery.of(context);
    double availableWidth = mediaQuery.size.width - 120;
    availableWidth -= 32 * 1;
    appBarHeight = mediaQuery.size.height / 3;
    return SliverAppBar(
      expandedHeight: appBarHeight,
      forceElevated: false,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: new Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: availableWidth,
              ),
              child: AnimatedDefaultTextStyle(
                child: new Text(widget.movie.title),
                duration: new Duration(milliseconds: 300),
                style: TextStyle(color: Colors.white, fontSize: isShrink ? 19.0 : 20.0),
//                          textScaleFactor: 0.8,
                maxLines: isShrink ? 1 : 2,
                overflow: isShrink ? TextOverflow.ellipsis : TextOverflow.fade,
              ),
            ),
          ),
          background: new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new CachedNetworkImage(
                  placeholder: new Container(
                      child: new Center(
                        child:  new CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                        ),
                      )
                  ),
                  width: MediaQuery.of(context).size.width,
                  imageUrl: widget.movie.backdropPath,
                  fit: BoxFit.cover,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.0, 1.0),
                      end: Alignment(0.5, 0.2),
                      colors: <Color>[Color(0x60000000), Color(0x00000000)],
                    ),
                  ),
                ),
              ]
          )
      ),
      actions: <Widget>[
        new IconButton(
            icon: new Icon(!widget.movie.isFavourite ? FontAwesomeIcons.heart : FontAwesomeIcons.solidHeart, size: 25.0, color: AppColors.pinkColor),
            onPressed: () {
              //Todo: Implement
            }
        )
      ],
    );
  }

  Widget _sliverList() {
    return SliverList(
        delegate: SliverChildListDelegate(
            <Widget>[
              Container(
                child: new Column(
                  children: <Widget>[
                    _moviePosterDetails(),
                    _movieOverview(),
                    _movieCasts(),
                    _movieCrew(),
                    _movieTrailers(),
                    _movieReviews()
                  ],
                ),
              ),
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    movieDetailsBlocState = MovieDetailsBlocWidget.of(context);
    return Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            _sliverAppBar(),
            _sliverList()
          ]
        )
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }
}
