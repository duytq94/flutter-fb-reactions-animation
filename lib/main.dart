import 'package:facebook_reaction_animation/fb_reaction_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(new MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter demo by duytq',
        theme: new ThemeData(primaryColor: Colors.amber, accentColor: Colors.amber),
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text(
                'MAIN',
                style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: new MainScreen()));
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return new SingleChildScrollView(
      child: new Center(
        child: new Column(
          children: <Widget>[
            buildButton(context, 'FB reaction animation screen', new FbReactionBox()),
          ],
        ),
      ),
      padding: new EdgeInsets.only(top: 15.0, bottom: 15.0),
    );
  }

  Widget buildButton(BuildContext context, String name, StatelessWidget screenTo) {
    return new Container(
      child: new FlatButton(
        onPressed: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => screenTo)),
        child: new Container(
          child: new Text(
            name,
            style: new TextStyle(color: Colors.white, fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
          width: 270.0,
        ),
        color: new Color(0xff03a9f4),
        highlightColor: new Color(0xffbae3fa),
        padding: new EdgeInsets.all(12.0),
      ),
      margin: new EdgeInsets.all(8.0),
    );
  }
}
