// Core
import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;
import 'dart:math';

// Models
import 'package:movies_app/app/models/movie_model.dart';

// UI Widgets
import 'package:movies_app/app/ui/widgets/movie_card.dart';

class MoviesCardFlipper extends StatefulWidget {
  final List<MovieModel> movies;
  final Function onScroll;

  MoviesCardFlipper({this.movies, this.onScroll});

  @override
  State<StatefulWidget> createState() {
    return _MoviesCardFlipperState();
  }
}

class _MoviesCardFlipperState extends State<MoviesCardFlipper> with TickerProviderStateMixin {
  double scrollPercent = 0.0;
  Offset startDrag;
  double startDragPercentScroll;
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController finishScrollController;

  @override
  void initState() {
    super.initState();
    finishScrollController = new AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          scrollPercent = lerpDouble(finishScrollStart, finishScrollEnd, finishScrollController.value);

          if (widget.onScroll != null) {
            widget.onScroll(scrollPercent);
          }
        });
      })
      ..addStatusListener((AnimationStatus status) {});
  }

  void _onPanStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final currDrag = details.globalPosition;
    final dragDistance = currDrag.dx - startDrag.dx;
    final singleCardDragPercent = dragDistance / context.size.width;

    setState(() {
      scrollPercent = (startDragPercentScroll + (-singleCardDragPercent / widget.movies.length)).clamp(0.0, 1.0 - (1 / widget.movies.length));

      if (widget.onScroll != null) {
        widget.onScroll(scrollPercent);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    finishScrollStart = scrollPercent;
    finishScrollEnd = (scrollPercent * widget.movies.length).round() / widget.movies.length;
    finishScrollController.forward(from: 0.0);

    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
    });
  }

  List<Widget> _buildCards() {
    int index = -1;
    return widget.movies.map((MovieModel movie) {
      ++index;
      return _buildCard(movie, index, widget.movies.length, scrollPercent);
    }).toList();
  }

  Matrix4 _buildCardProjection(double scrollPercent) {
    final perspective = 0.002;
    final radius = 1.0;
    final angle = scrollPercent * pi / 8;
    final horizontalTranslation = 0.0;
    Matrix4 projection = new Matrix4.identity()
      ..setEntry(0, 0, 1 / radius)
      ..setEntry(1, 1, 1 / radius)
      ..setEntry(3, 2, -perspective)
      ..setEntry(2, 3, -radius)
      ..setEntry(3, 3, perspective * radius + 1.0);

    // Model matrix by first translating the object from the origin of the world
    // by radius in the z axis and then rotating against the world.
    final rotationPointMultiplier = angle > 0.0 ? angle / angle.abs() : 1.0;
    projection *= new Matrix4.translationValues(
        horizontalTranslation + (rotationPointMultiplier * 300.0), 0.0, 0.0) *
        new Matrix4.rotationY(angle) *
        new Matrix4.translationValues(0.0, 0.0, radius) *
        new Matrix4.translationValues(-rotationPointMultiplier * 300.0, 0.0, 0.0);

    return projection;
  }

  Widget _buildCard(
      MovieModel movie,
      int cardIndex,
      int cardCount,
      double scrollPercent,
      ) {
    final cardScrollPercent = scrollPercent / (1 / cardCount);
    final parallax = scrollPercent - (cardIndex / widget.movies.length);

    return new FractionalTranslation(
      translation: new Offset(cardIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
        child: new Transform(
          transform: _buildCardProjection(cardScrollPercent - cardIndex),
          child: new MovieCard(
            movie: movie,
            parallaxPercent: parallax,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onPanStart,
      onHorizontalDragUpdate: _onPanUpdate,
      onHorizontalDragEnd: _onPanEnd,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: _buildCards(),
      ),
    );
  }
}