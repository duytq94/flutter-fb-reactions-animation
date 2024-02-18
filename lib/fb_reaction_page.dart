import 'package:facebook_reaction_animation/fb_reaction_box.dart';
import 'package:flutter/material.dart';

class FbReactionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Facebook Reaction',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FbReactionBox(),
    );
  }
}
