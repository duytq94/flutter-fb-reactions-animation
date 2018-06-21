import 'package:facebook_reaction_animation/fb_reaction_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(new MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Welcome to Flutter',
        theme: new ThemeData(primaryColor: new Color(0xff3b5998), accentColor: new Color(0xff3b5998)),
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('MAIN'),
              centerTitle: true,
            ),
            body: new MainScreen()));
  }
}

class MainScreen extends StatefulWidget {
  final double timeDelay;

  MainScreen({this.timeDelay});

  @override
  State createState() => new MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  double timeDelay = 1.0;
  TextEditingController editingController = new TextEditingController();
  List<Color> btnColors = new List(5);

  onSpeedSettingPress(double value, int index) {
    setState(() {
      timeDelay = value;
      for (int i = 0; i < 5; i++) {
        if (i == index) {
          btnColors[i] = new Color(0xff3b5998);
        } else {
          btnColors[i] = new Color(0xffDAA520);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      btnColors[i] = new Color(0xffDAA520);
    }
    btnColors[0] = new Color(0xff3b5998);
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = timeDelay;
    return new Material(
      child: new Center(
          child: new Column(
        children: <Widget>[
          new Container(
            child: new Row(
              children: <Widget>[
                new Text(
                  'SPEED:',
                  style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
                new Container(
                  child: new GestureDetector(
                    onTap: () => onSpeedSettingPress(1.0, 0),
                    child: new Container(
                      child: new Text('1.0', style: new TextStyle(color: Colors.white)),
                      padding: new EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                        color: btnColors[0],
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  margin: new EdgeInsets.all(5.0),
                ),
                new Container(
                  child: new GestureDetector(
                    onTap: () => onSpeedSettingPress(2.0, 1),
                    child: new Container(
                      child: new Text('2.0', style: new TextStyle(color: Colors.white)),
                      padding: new EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                        color: btnColors[1],
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  margin: new EdgeInsets.all(5.0),
                ),
                new Container(
                  child: new GestureDetector(
                    onTap: () => onSpeedSettingPress(3.0, 2),
                    child: new Container(
                      child: new Text('3.0', style: new TextStyle(color: Colors.white)),
                      padding: new EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                        color: btnColors[2],
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  margin: new EdgeInsets.all(5.0),
                ),
                new Container(
                  child: new GestureDetector(
                    onTap: () => onSpeedSettingPress(4.0, 3),
                    child: new Container(
                      child: new Text('4.0', style: new TextStyle(color: Colors.white)),
                      padding: new EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                        color: btnColors[3],
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  margin: new EdgeInsets.all(5.0),
                ),
                new Container(
                  child: new GestureDetector(
                    onTap: () => onSpeedSettingPress(5.0, 4),
                    child: new Container(
                      child: new Text('5.0', style: new TextStyle(color: Colors.white)),
                      padding: new EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                        color: btnColors[4],
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  margin: new EdgeInsets.all(5.0),
                ),
              ],
            ),
            margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
          ),
          new Container(
            height: 15.0,
          ),
          buildButton(context, 'Restaurant animation screen', new FbReactionBox())
        ],
      )),
    );
  }

  Widget buildButton(BuildContext context, String name, StatelessWidget screenTo) {
    return new FlatButton(
      onPressed: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => screenTo)),
      child: new Container(
        child: new Text(
          name,
          style: new TextStyle(color: Colors.white, fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
        width: 270.0,
      ),
      color: new Color(0xff3b5998),
      highlightColor: new Color(0xff1E90FF),
      padding: new EdgeInsets.all(12.0),
    );
  }
}
