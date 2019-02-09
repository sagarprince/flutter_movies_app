// Core
import 'package:flutter/material.dart';

// Bloc Provider
import 'package:movies_app/app/blocs/movies_bloc_provider.dart';

// UI Widgets
import 'package:movies_app/app/ui/widgets/custom_app_bar.dart';
import 'package:movies_app/app/ui/movies_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new MoviesBlocWidget(
        child: new Container(
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new CustomAppBar(),
              new MoviesList()
            ],
          ),
        ),
      )
    );
  }
}
