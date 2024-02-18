import 'package:facebook_reaction_animation/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook Reactions by Flutter',
      theme: ThemeData(primaryColor: Color(0xff3b5998)),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
