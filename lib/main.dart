// Core
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Theme
import 'package:movies_app/app/theme.dart';

// Widgets
import 'app/app.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
        runApp(
            MaterialApp(
                title: 'Movies',
                debugShowCheckedModeBanner: false,
                theme: themeData,
                home: App()
            )
        );
  });
}
