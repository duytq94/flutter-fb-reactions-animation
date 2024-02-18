import 'package:facebook_reaction_animation/fb_reaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _timeDelays = [1.0, 2.0, 3.0, 4.0, 5.0];
  int _selectedIndex = 0;

  void _onSpeedSettingPress(int index) {
    timeDilation = _timeDelays[index];
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _buildListDelays() {
    final result = <Widget>[
      Text(
        'Delay:',
        style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
      )
    ];
    _timeDelays.asMap().forEach(
      (index, delay) {
        result.add(
          Container(
            child: GestureDetector(
              onTap: () => _onSpeedSettingPress(index),
              child: Container(
                child: Text(delay.toString(), style: TextStyle(color: Colors.white)),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: index == _selectedIndex ? Color(0xff3b5998) : Color(0xffDAA520),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            margin: EdgeInsets.all(5.0),
          ),
        );
      },
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Row(
                children: _buildListDelays(),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
            ),
            Container(
              height: 15.0,
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FbReactionPage())),
              child: Container(
                child: Text(
                  "Let's try",
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                width: 270.0,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(MaterialState.pressed)) return Color(0xff3b5998).withOpacity(0.8);
                    return Color(0xff3b5998);
                  },
                ),
                splashFactory: NoSplash.splashFactory,
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.fromLTRB(30, 15, 30, 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
