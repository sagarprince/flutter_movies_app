// Core
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Theme
import 'package:movies_app/app/theme.dart';

// Models
import 'package:movies_app/app/models/movie_model.dart';

// Bloc Provider
import 'package:movies_app/app/blocs/movies_bloc_provider.dart';
import 'package:movies_app/app/blocs/movie_details_bloc_provider.dart';

// Page Widgets
import 'package:movies_app/app/ui/movie_details.dart';


class MovieCard extends StatefulWidget {
  final MovieModel movie;
  final double parallaxPercent;

  MovieCard({
    this.movie,
    this.parallaxPercent
  });

  @override
  State<StatefulWidget> createState() {
    return _MovieCardState();
  }
}

class _MovieCardState extends State<MovieCard> with TickerProviderStateMixin {
  BuildContext _context;
  MoviesBlocWidgetState blocState;
  GlobalKey _posterKey = GlobalKey();
  double startDragY;
  double dragOffset;
  double posterOffsetY = 0.0;
  double posterClampUp = -0.09;
  double posterClampDown = 0.0;
  bool isPosterUp = false;
  AnimationController animationController;
  AnimationController favouriteAnimationController;
  Animation favouriteAnimation;
  double posterWidth = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    initAnimationCard();
    initAnimationFavourite();
  }

  initAnimationCard() {
    animationController = new AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          posterOffsetY = dragOffset;
        });
      })
      ..addStatusListener((AnimationStatus status) {});
  }

  initAnimationFavourite() {
    favouriteAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500)
    )
        ..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            favouriteAnimationController.reverse();
          }
        })
        ..addListener(() {
          setState(() {});
        });
    favouriteAnimation = Tween(begin: 1.0, end: 1.40).animate(favouriteAnimationController);
  }

  _afterLayout(_) {
    final RenderBox posterBox = _posterKey.currentContext.findRenderObject();
    setState(() {
      posterWidth = posterBox.size.width - 60;
    });
  }


  void _onPanStart(DragStartDetails details) {
    startDragY = details.globalPosition.dy;
    posterClampUp = -50.0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final currDrag = details.globalPosition;
    final dragDistance = currDrag.dy - startDragY;
    dragOffset = (dragDistance).clamp(posterClampUp, posterClampDown);
    animationController.forward(from: 1.0);
  }

  void _onPanEnd(DragEndDetails details) {
    startDragY = null;
  }

  void _onMovieDetails({bool isShowTrailers = false}) {
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) {
        return new MovieDetailsBlocWidget(
            movie: widget.movie,
            child: new MovieDetails(
                movie: widget.movie,
                isShowTrailers: isShowTrailers
            )
        );
      })
    );
  }

  Widget _moviePosterImage() {
    return new Expanded(
      child: new OverflowBox(
          child: new Hero(
            tag: widget.movie.id.toString(),
            child: new Material(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              clipBehavior: Clip.hardEdge,
              child: new CachedNetworkImage(
                placeholder: new Container(
                    width: posterWidth,
                    child: new Center(
                      child:  new CircularProgressIndicator(
                        strokeWidth: 3.0,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                      ),
                    )
                ),
                width: posterWidth,
                imageUrl: widget.movie.posterPath,
                fit: BoxFit.cover,
              ),
            )
          )
      ),
    );
  }

  Widget _movieTrailersFavouriteAction() {
    return new Container(
      margin: EdgeInsets.only(top: 15.0, left: 10.0, right: 0.0),
      child: new Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new GestureDetector(
           child: new Text('Trailers', style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            onTap: () {
              _onMovieDetails(isShowTrailers: true);
            },
          ),
          Transform.scale(
            child: new IconButton(
                icon: new Icon(!widget.movie.isFavourite ? FontAwesomeIcons.heart : FontAwesomeIcons.solidHeart, size: 25.0, color: AppColors.pinkColor),
                onPressed: () {
                  favouriteAnimationController.forward();
                  setState(() {
                    widget.movie.isFavourite = !widget.movie.isFavourite;
                    if (widget.movie.isFavourite) {
                      blocState.addToFavourites(widget.movie);
                    } else {
                      blocState.removeFromFavourites(widget.movie);
                    }
                  });
                }
            ),
            scale: favouriteAnimation.value,
          )
        ],
      ),
    );
  }

  Widget _moviePoster() {
    return new Expanded(
        flex: 1,
        key: _posterKey,
        child: new Stack(
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _movieTrailersFavouriteAction()
              ],
            ),
            new Transform.translate(
              offset: Offset(0.0, posterOffsetY),
              child: new GestureDetector(
                onVerticalDragStart: _onPanStart,
                onVerticalDragUpdate: _onPanUpdate,
                onVerticalDragEnd: _onPanEnd,
                onTap: _onMovieDetails,
                child: new Column(
                  children: <Widget>[
                    _moviePosterImage(),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }

  Widget _movieInfo() {
    return new Container(
        margin: EdgeInsets.only(top: 20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(widget.movie.title, style: AppTextStyles.movieCardTitle, textAlign: TextAlign.center),
            new Container(
                margin: EdgeInsets.only(top: 5.0),
                child: new Text(widget.movie.genres, style: AppTextStyles.movieCardGeners, textAlign: TextAlign.center)
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    blocState = MoviesBlocWidget.of(context, false);
    return new Container(
        child: new Column(
          children: <Widget>[
            _moviePoster(),
            _movieInfo()
          ],
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
    favouriteAnimationController.dispose();
    animationController.dispose();
  }
}