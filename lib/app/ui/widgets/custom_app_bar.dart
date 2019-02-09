import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Theme
import 'package:movies_app/app/theme.dart';

// Bloc Provider
import 'package:movies_app/app/blocs/movies_bloc_provider.dart';

// Utilities
import 'package:movies_app/app/utilities.dart';

class AppBarShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.20, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
    Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 30);
    path.lineTo(size.width, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class FavouriteMoviesCount extends StatefulWidget {
  final int count;

  FavouriteMoviesCount({Key key, this.count}) :
        assert(count >= 0),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FavouriteMoviesCountState();
  }
}

class _FavouriteMoviesCountState extends State<FavouriteMoviesCount> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  Tween<double> animationTween;

  @override
  void initState() {
    super.initState();
    initAnimation();
  }

  initAnimation() {
    animationController = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300)
    )
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        }
      })
      ..addListener(() {
        setState(() {});
      });
    animation = Tween(begin: 1.0, end: 1.60).animate(animationController);
  }

  @override
  void didUpdateWidget(FavouriteMoviesCount oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      animationController.reset();
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
          children: <Widget>[
            new Icon(
                widget.count > 0 ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                size: 30.0,
                color: widget.count == 0 ? AppColors.whiteColor : AppColors.pinkColor
            ),
            widget.count > 0 ?
            new Positioned(
                top: 4,
                left: 4,
                child: Transform.scale(
                  scale: animation.value,
                  child: new Container(
                      width: 20.0,
                      height: 20.0,
                      child: new Center(
                          child: new Text(widget.count.toString(), textAlign: TextAlign.center, style: new TextStyle(fontSize: 17.0, color: AppColors.whiteColor))
                      )
                  ),
                )
            ) : new Container()
          ],
        )
    );
  }
}

class CustomAppBar extends StatelessWidget {
  MoviesBlocWidgetState blocState;

  Widget _favouriteMoviesCount() {
    return new FavouriteMoviesCount(
      count: blocState.favourites.length,
    );
  }

  Widget _appTitle() {
    return Container(
        child: new Text('Movies', style: AppTextStyles.appTitle)
    );
  }

  Widget _searchMoviesAction() {
    return new Container(
      child: IconButton(
        icon: new Icon(Icons.search, size: 38.0, color: AppColors.whiteColor),
        onPressed: () {
          blocState.searchMovies('');
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    blocState = MoviesBlocWidget.of(context);
    final double appBarHeight = Utilities.get().getAppBarHeight(context);
    final double appBarTopPosition = Utilities.get().getAppBarTopPosition(context);
    return new Stack(
      children: <Widget>[
        ClipPath(
          clipper: AppBarShapeClipper(),
          child: new Container(
            height: appBarHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.secondaryColor]
              ),
            ),
            child: new Stack(
              children: <Widget>[
                new Positioned(
                  top: appBarTopPosition,
                  width: MediaQuery.of(context).size.width,
                  child: new Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _favouriteMoviesCount(),
                      _appTitle(),
                      _searchMoviesAction()
                    ],
                  ),
                )
              ],
            )
          ),
        )
      ],
    );
  }
}