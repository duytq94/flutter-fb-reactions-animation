import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:facebook_reaction_animation/const.dart';
import 'package:flutter/material.dart';

class FbReactionBox extends StatefulWidget {
  @override
  createState() => FbReactionBoxState();
}

class FbReactionBoxState extends State<FbReactionBox> with TickerProviderStateMixin {
  final _audioPlayer = AudioPlayer();

  int _durationAnimationBox = 500;
  int _durationAnimationBtnLongPress = 150;
  int _durationAnimationBtnShortPress = 500;
  int _durationAnimationEmojiWhenDrag = 150;
  int _durationAnimationEmojiWhenRelease = 1000;

  // For long press btn
  late AnimationController _animControlBtnLongPress, _animControlBox;
  late Animation _zoomEmojiLikeInBtn, _tiltEmojiLikeInBtn, _zoomTextLikeInBtn;
  late Animation _fadeInBox;
  late Animation _moveRightGroupEmoji;
  late Animation _pushEmojiLikeUp,
      _pushEmojiLoveUp,
      _pushEmojiHahaUp,
      _pushEmojiWowUp,
      _pushEmojiSadUp,
      _pushEmojiAngryUp;
  late Animation _zoomEmojiLike, _zoomEmojiLove, _zoomEmojiHaha, _zoomEmojiWow, _zoomEmojiSad, _zoomEmojiAngry;

  // For short press btn
  late AnimationController _animControlBtnShortPress;
  late Animation _zoomEmojiLikeInBtn2, _tiltEmojiLikeInBtn2;

  // For zoom emoji when drag
  late AnimationController _animControlEmojiWhenDrag;
  late AnimationController _animControlEmojiWhenDragInside;
  late AnimationController _animControlEmojiWhenDragOutside;
  late AnimationController _animControlBoxWhenDragOutside;
  late Animation _zoomEmojiChosen, _zoomEmojiNotChosen;
  late Animation _zoomEmojiWhenDragOutside;
  late Animation _zoomEmojiWhenDragInside;
  late Animation _zoomBoxWhenDragOutside;
  late Animation _zoomBoxEmoji;

  // For jump emoji when release
  late AnimationController _animControlEmojiWhenRelease;
  late Animation _zoomEmojiWhenRelease, _moveUpEmojiWhenRelease;
  late Animation _moveLeftEmojiLikeWhenRelease,
      _moveLeftEmojiLoveWhenRelease,
      _moveLeftEmojiHahaWhenRelease,
      _moveLeftEmojiWowWhenRelease,
      _moveLeftEmojiSadWhenRelease,
      _moveLeftEmojiAngryWhenRelease;

  final _durationLongPress = Duration(milliseconds: 250);
  late Timer _holdTimer;
  bool _isLongPress = false;
  bool _isLiked = false;

  ReactionEmoji _emojiUserChoose = ReactionEmoji.nothing;
  ReactionEmoji _currentEmojiFocus = ReactionEmoji.nothing;
  ReactionEmoji _previousEmojiFocus = ReactionEmoji.nothing;
  bool _isDragging = false;
  bool _isDraggingOutside = false;
  bool _isJustDragInside = true;

  @override
  void initState() {
    super.initState();

    // Button Like
    _initAnimationBtnLike();

    // Box and Emojis
    _initAnimationBoxAndEmojis();

    // Emoji when drag
    _initAnimationEmojiWhenDrag();

    // Emoji when drag outside
    _initAnimationEmojiWhenDragOutside();

    // Box when drag outside
    _initAnimationBoxWhenDragOutside();

    // Emoji when first drag
    _initAnimationEmojiWhenDragInside();

    // Emoji when release
    _initAnimationEmojiWhenRelease();
  }

  void _initAnimationBtnLike() {
    // long press
    _animControlBtnLongPress =
        AnimationController(vsync: this, duration: Duration(milliseconds: _durationAnimationBtnLongPress));
    _zoomEmojiLikeInBtn = Tween(begin: 1.0, end: 0.85).animate(_animControlBtnLongPress);
    _tiltEmojiLikeInBtn = Tween(begin: 0.0, end: 0.2).animate(_animControlBtnLongPress);
    _zoomTextLikeInBtn = Tween(begin: 1.0, end: 0.85).animate(_animControlBtnLongPress);

    _zoomEmojiLikeInBtn.addListener(() {
      setState(() {});
    });
    _tiltEmojiLikeInBtn.addListener(() {
      setState(() {});
    });
    _zoomTextLikeInBtn.addListener(() {
      setState(() {});
    });

    // short press
    _animControlBtnShortPress =
        AnimationController(vsync: this, duration: Duration(milliseconds: _durationAnimationBtnShortPress));
    _zoomEmojiLikeInBtn2 = Tween(begin: 1.0, end: 0.2).animate(_animControlBtnShortPress);
    _tiltEmojiLikeInBtn2 = Tween(begin: 0.0, end: 0.8).animate(_animControlBtnShortPress);

    _zoomEmojiLikeInBtn2.addListener(() {
      setState(() {});
    });
    _tiltEmojiLikeInBtn2.addListener(() {
      setState(() {});
    });
  }

  void _initAnimationBoxAndEmojis() {
    _animControlBox = AnimationController(vsync: this, duration: Duration(milliseconds: _durationAnimationBox));

    // General
    _moveRightGroupEmoji = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.0, 1.0)),
    );
    _moveRightGroupEmoji.addListener(() {
      setState(() {});
    });

    // Box
    _fadeInBox = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.7, 1.0)),
    );
    _fadeInBox.addListener(() {
      setState(() {});
    });

    // Emoji
    _pushEmojiLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.0, 0.5)),
    );
    _zoomEmojiLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.0, 0.5)),
    );

    _pushEmojiLoveUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.1, 0.6)),
    );
    _zoomEmojiLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.1, 0.6)),
    );

    _pushEmojiHahaUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.2, 0.7)),
    );
    _zoomEmojiHaha = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.2, 0.7)),
    );

    _pushEmojiWowUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.3, 0.8)),
    );
    _zoomEmojiWow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.3, 0.8)),
    );

    _pushEmojiSadUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.4, 0.9)),
    );
    _zoomEmojiSad = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.4, 0.9)),
    );

    _pushEmojiAngryUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.5, 1.0)),
    );
    _zoomEmojiAngry = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.5, 1.0)),
    );

    _pushEmojiLikeUp.addListener(() {
      setState(() {});
    });
    _zoomEmojiLike.addListener(() {
      setState(() {});
    });
    _pushEmojiLoveUp.addListener(() {
      setState(() {});
    });
    _zoomEmojiLove.addListener(() {
      setState(() {});
    });
    _pushEmojiHahaUp.addListener(() {
      setState(() {});
    });
    _zoomEmojiHaha.addListener(() {
      setState(() {});
    });
    _pushEmojiWowUp.addListener(() {
      setState(() {});
    });
    _zoomEmojiWow.addListener(() {
      setState(() {});
    });
    _pushEmojiSadUp.addListener(() {
      setState(() {});
    });
    _zoomEmojiSad.addListener(() {
      setState(() {});
    });
    _pushEmojiAngryUp.addListener(() {
      setState(() {});
    });
    _zoomEmojiAngry.addListener(() {
      setState(() {});
    });
  }

  void _initAnimationEmojiWhenDrag() {
    _animControlEmojiWhenDrag =
        AnimationController(vsync: this, duration: Duration(milliseconds: _durationAnimationEmojiWhenDrag));

    _zoomEmojiChosen = Tween(begin: 1.0, end: 1.8).animate(_animControlEmojiWhenDrag);
    _zoomEmojiNotChosen = Tween(begin: 1.0, end: 0.8).animate(_animControlEmojiWhenDrag);
    _zoomBoxEmoji = Tween(begin: 50.0, end: 40.0).animate(_animControlEmojiWhenDrag);

    _zoomEmojiChosen.addListener(() {
      setState(() {});
    });
    _zoomEmojiNotChosen.addListener(() {
      setState(() {});
    });
    _zoomBoxEmoji.addListener(() {
      setState(() {});
    });
  }

  void _initAnimationEmojiWhenDragOutside() {
    _animControlEmojiWhenDragOutside =
        AnimationController(vsync: this, duration: Duration(milliseconds: _durationAnimationEmojiWhenDrag));
    _zoomEmojiWhenDragOutside = Tween(begin: 0.8, end: 1.0).animate(_animControlEmojiWhenDragOutside);
    _zoomEmojiWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  void _initAnimationBoxWhenDragOutside() {
    _animControlBoxWhenDragOutside =
        AnimationController(vsync: this, duration: Duration(milliseconds: _durationAnimationEmojiWhenDrag));
    _zoomBoxWhenDragOutside = Tween(begin: 40.0, end: 50.0).animate(_animControlBoxWhenDragOutside);
    _zoomBoxWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  void _initAnimationEmojiWhenDragInside() {
    _animControlEmojiWhenDragInside =
        AnimationController(vsync: this, duration: Duration(milliseconds: _durationAnimationEmojiWhenDrag));
    _zoomEmojiWhenDragInside = Tween(begin: 1.0, end: 0.8).animate(_animControlEmojiWhenDragInside);
    _zoomEmojiWhenDragInside.addListener(() {
      setState(() {});
    });
    _animControlEmojiWhenDragInside.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isJustDragInside = false;
      }
    });
  }

  void _initAnimationEmojiWhenRelease() {
    _animControlEmojiWhenRelease =
        AnimationController(vsync: this, duration: Duration(milliseconds: _durationAnimationEmojiWhenRelease));

    _zoomEmojiWhenRelease = Tween(begin: 1.8, end: 0.0)
        .animate(CurvedAnimation(parent: _animControlEmojiWhenRelease, curve: Curves.decelerate));

    _moveUpEmojiWhenRelease = Tween(begin: 180.0, end: 0.0)
        .animate(CurvedAnimation(parent: _animControlEmojiWhenRelease, curve: Curves.decelerate));

    _moveLeftEmojiLikeWhenRelease = Tween(begin: 20.0, end: 10.0)
        .animate(CurvedAnimation(parent: _animControlEmojiWhenRelease, curve: Curves.decelerate));
    _moveLeftEmojiLoveWhenRelease = Tween(begin: 68.0, end: 10.0)
        .animate(CurvedAnimation(parent: _animControlEmojiWhenRelease, curve: Curves.decelerate));
    _moveLeftEmojiHahaWhenRelease = Tween(begin: 116.0, end: 10.0)
        .animate(CurvedAnimation(parent: _animControlEmojiWhenRelease, curve: Curves.decelerate));
    _moveLeftEmojiWowWhenRelease = Tween(begin: 164.0, end: 10.0)
        .animate(CurvedAnimation(parent: _animControlEmojiWhenRelease, curve: Curves.decelerate));
    _moveLeftEmojiSadWhenRelease = Tween(begin: 212.0, end: 10.0)
        .animate(CurvedAnimation(parent: _animControlEmojiWhenRelease, curve: Curves.decelerate));
    _moveLeftEmojiAngryWhenRelease = Tween(begin: 260.0, end: 10.0)
        .animate(CurvedAnimation(parent: _animControlEmojiWhenRelease, curve: Curves.decelerate));

    _zoomEmojiWhenRelease.addListener(() {
      setState(() {});
    });
    _moveUpEmojiWhenRelease.addListener(() {
      setState(() {});
    });

    _moveLeftEmojiLikeWhenRelease.addListener(() {
      setState(() {});
    });
    _moveLeftEmojiLoveWhenRelease.addListener(() {
      setState(() {});
    });
    _moveLeftEmojiHahaWhenRelease.addListener(() {
      setState(() {});
    });
    _moveLeftEmojiWowWhenRelease.addListener(() {
      setState(() {});
    });
    _moveLeftEmojiSadWhenRelease.addListener(() {
      setState(() {});
    });
    _moveLeftEmojiAngryWhenRelease.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animControlBtnLongPress.dispose();
    _animControlBox.dispose();
    _animControlEmojiWhenDrag.dispose();
    _animControlEmojiWhenDragInside.dispose();
    _animControlEmojiWhenDragOutside.dispose();
    _animControlBoxWhenDragOutside.dispose();
    _animControlEmojiWhenRelease.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          // Just a top space
          Container(
            width: double.infinity,
            height: 100.0,
          ),

          // main content
          Container(
            child: Stack(
              children: [
                // Box and emoji
                Stack(
                  children: [
                    // Box
                    _renderBox(),

                    // Emojis
                    _renderEmoji(),
                  ],
                  alignment: Alignment.bottomCenter,
                ),

                // Button like
                _renderBtnLike(),

                // Emojis when jump
                // Emoji like
                _emojiUserChoose == ReactionEmoji.like && !_isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            AssetImages.likeGif,
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this._zoomEmojiWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: _processTopPosition(this._moveUpEmojiWhenRelease.value),
                          left: this._moveLeftEmojiLikeWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Emoji love
                _emojiUserChoose == ReactionEmoji.love && !_isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            AssetImages.loveGif,
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this._zoomEmojiWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: _processTopPosition(this._moveUpEmojiWhenRelease.value),
                          left: this._moveLeftEmojiLoveWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Emoji haha
                _emojiUserChoose == ReactionEmoji.haha && !_isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            AssetImages.hahaGif,
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this._zoomEmojiWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: _processTopPosition(this._moveUpEmojiWhenRelease.value),
                          left: this._moveLeftEmojiHahaWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Emoji Wow
                _emojiUserChoose == ReactionEmoji.wow && !_isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            AssetImages.wowGif,
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this._zoomEmojiWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: _processTopPosition(this._moveUpEmojiWhenRelease.value),
                          left: this._moveLeftEmojiWowWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Emoji sad
                _emojiUserChoose == ReactionEmoji.sad && !_isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            AssetImages.sadGif,
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this._zoomEmojiWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: _processTopPosition(this._moveUpEmojiWhenRelease.value),
                          left: this._moveLeftEmojiSadWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Emoji angry
                _emojiUserChoose == ReactionEmoji.angry && !_isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            AssetImages.angryGif,
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this._zoomEmojiWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: _processTopPosition(this._moveUpEmojiWhenRelease.value),
                          left: this._moveLeftEmojiAngryWhenRelease.value,
                        ),
                      )
                    : Container(),
              ],
            ),
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            // Area of the content can drag
            // decoration:  BoxDecoration(border: Border.all(color: Colors.grey)),
            width: double.infinity,
            height: 350.0,
          ),
        ],
      ),
      onHorizontalDragEnd: _onHorizontalDragEndBoxEmoji,
      onHorizontalDragUpdate: _onHorizontalDragUpdateBoxEmoji,
    );
  }

  Widget _renderBox() {
    return Opacity(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.grey.shade300, width: 0.3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              offset: Offset.lerp(Offset(0.0, 0.0), Offset(0.0, 0.5), 10.0)!,
            ),
          ],
        ),
        width: 300.0,
        height: _isDragging
            ? _previousEmojiFocus == ReactionEmoji.nothing
                ? this._zoomBoxEmoji.value
                : 40.0
            : _isDraggingOutside
                ? this._zoomBoxWhenDragOutside.value
                : 50.0,
        margin: EdgeInsets.only(bottom: 130.0, left: 10.0),
      ),
      opacity: this._fadeInBox.value,
    );
  }

  Widget _renderEmoji() {
    return Container(
      child: Row(
        children: [
          // emoji like
          Transform.scale(
            child: Container(
              child: Column(
                children: [
                  _currentEmojiFocus == ReactionEmoji.like
                      ? Container(
                          child: Text(
                            'Like',
                            style: TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    AssetImages.likeGif,
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: _pushEmojiLikeUp.value),
              width: 40.0,
              height: _currentEmojiFocus == ReactionEmoji.like ? 70.0 : 40.0,
            ),
            scale: _isDragging
                ? (_currentEmojiFocus == ReactionEmoji.like
                    ? this._zoomEmojiChosen.value
                    : (_previousEmojiFocus == ReactionEmoji.like
                        ? this._zoomEmojiNotChosen.value
                        : _isJustDragInside
                            ? this._zoomEmojiWhenDragInside.value
                            : 0.8))
                : _isDraggingOutside
                    ? this._zoomEmojiWhenDragOutside.value
                    : this._zoomEmojiLike.value,
          ),

          // emoji love
          Transform.scale(
            child: Container(
              child: Column(
                children: [
                  _currentEmojiFocus == ReactionEmoji.love
                      ? Container(
                          child: Text(
                            'Love',
                            style: TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    AssetImages.loveGif,
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: _pushEmojiLoveUp.value),
              width: 40.0,
              height: _currentEmojiFocus == ReactionEmoji.love ? 70.0 : 40.0,
            ),
            scale: _isDragging
                ? (_currentEmojiFocus == ReactionEmoji.love
                    ? this._zoomEmojiChosen.value
                    : (_previousEmojiFocus == ReactionEmoji.love
                        ? this._zoomEmojiNotChosen.value
                        : _isJustDragInside
                            ? this._zoomEmojiWhenDragInside.value
                            : 0.8))
                : _isDraggingOutside
                    ? this._zoomEmojiWhenDragOutside.value
                    : this._zoomEmojiLove.value,
          ),

          // emoji haha
          Transform.scale(
            child: Container(
              child: Column(
                children: [
                  _currentEmojiFocus == ReactionEmoji.haha
                      ? Container(
                          child: Text(
                            'Haha',
                            style: TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    AssetImages.hahaGif,
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: _pushEmojiHahaUp.value),
              width: 40.0,
              height: _currentEmojiFocus == ReactionEmoji.haha ? 70.0 : 40.0,
            ),
            scale: _isDragging
                ? (_currentEmojiFocus == ReactionEmoji.haha
                    ? this._zoomEmojiChosen.value
                    : (_previousEmojiFocus == ReactionEmoji.haha
                        ? this._zoomEmojiNotChosen.value
                        : _isJustDragInside
                            ? this._zoomEmojiWhenDragInside.value
                            : 0.8))
                : _isDraggingOutside
                    ? this._zoomEmojiWhenDragOutside.value
                    : this._zoomEmojiHaha.value,
          ),

          // emoji wow
          Transform.scale(
            child: Container(
              child: Column(
                children: [
                  _currentEmojiFocus == ReactionEmoji.wow
                      ? Container(
                          child: Text(
                            'Wow',
                            style: TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    AssetImages.wowGif,
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: _pushEmojiWowUp.value),
              width: 40.0,
              height: _currentEmojiFocus == ReactionEmoji.wow ? 70.0 : 40.0,
            ),
            scale: _isDragging
                ? (_currentEmojiFocus == ReactionEmoji.wow
                    ? this._zoomEmojiChosen.value
                    : (_previousEmojiFocus == ReactionEmoji.wow
                        ? this._zoomEmojiNotChosen.value
                        : _isJustDragInside
                            ? this._zoomEmojiWhenDragInside.value
                            : 0.8))
                : _isDraggingOutside
                    ? this._zoomEmojiWhenDragOutside.value
                    : this._zoomEmojiWow.value,
          ),

          // emoji sad
          Transform.scale(
            child: Container(
              child: Column(
                children: [
                  _currentEmojiFocus == ReactionEmoji.sad
                      ? Container(
                          child: Text(
                            'Sad',
                            style: TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    AssetImages.sadGif,
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: _pushEmojiSadUp.value),
              width: 40.0,
              height: _currentEmojiFocus == ReactionEmoji.sad ? 70.0 : 40.0,
            ),
            scale: _isDragging
                ? (_currentEmojiFocus == ReactionEmoji.sad
                    ? this._zoomEmojiChosen.value
                    : (_previousEmojiFocus == ReactionEmoji.sad
                        ? this._zoomEmojiNotChosen.value
                        : _isJustDragInside
                            ? this._zoomEmojiWhenDragInside.value
                            : 0.8))
                : _isDraggingOutside
                    ? this._zoomEmojiWhenDragOutside.value
                    : this._zoomEmojiSad.value,
          ),

          // emoji angry
          Transform.scale(
            child: Container(
              child: Column(
                children: [
                  _currentEmojiFocus == ReactionEmoji.angry
                      ? Container(
                          child: Text(
                            'Angry',
                            style: TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    AssetImages.angryGif,
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: _pushEmojiAngryUp.value),
              width: 40.0,
              height: _currentEmojiFocus == ReactionEmoji.angry ? 70.0 : 40.0,
            ),
            scale: _isDragging
                ? (_currentEmojiFocus == ReactionEmoji.angry
                    ? this._zoomEmojiChosen.value
                    : (_previousEmojiFocus == ReactionEmoji.angry
                        ? this._zoomEmojiNotChosen.value
                        : _isJustDragInside
                            ? this._zoomEmojiWhenDragInside.value
                            : 0.8))
                : _isDraggingOutside
                    ? this._zoomEmojiWhenDragOutside.value
                    : this._zoomEmojiAngry.value,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      width: 300.0,
      height: 250.0,
      margin: EdgeInsets.only(left: this._moveRightGroupEmoji.value, top: 50.0),
      // uncomment here to see area of draggable
      // color: Colors.amber.withOpacity(0.5),
    );
  }

  Widget _renderBtnLike() {
    return Container(
      child: GestureDetector(
        onTapDown: _onTapDownBtn,
        onTapUp: _onTapUpBtn,
        onTap: _onTapBtn,
        child: Container(
          child: Row(
            children: [
              // Emoji like
              Transform.scale(
                child: Transform.rotate(
                  child: Image.asset(
                    _getImageEmojiBtn(),
                    width: 25.0,
                    height: 25.0,
                    fit: BoxFit.contain,
                    color: _getTintColorEmojiBtn(),
                  ),
                  angle: !_isLongPress
                      ? _handleOutputRangeTiltEmojiLike(_tiltEmojiLikeInBtn2.value)
                      : _tiltEmojiLikeInBtn.value,
                ),
                scale: !_isLongPress
                    ? _handleOutputRangeZoomInEmojiLike(_zoomEmojiLikeInBtn2.value)
                    : _zoomEmojiLikeInBtn.value,
              ),

              // Text like
              Transform.scale(
                child: Text(
                  _getTextBtn(),
                  style: TextStyle(
                    color: _getColorTextBtn(),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                scale: !_isLongPress
                    ? _handleOutputRangeZoomInEmojiLike(_zoomEmojiLikeInBtn2.value)
                    : _zoomTextLikeInBtn.value,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          padding: EdgeInsets.all(10.0),
          color: Colors.transparent,
        ),
      ),
      width: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
        border: Border.all(color: _getColorBorderBtn()),
      ),
      margin: EdgeInsets.only(top: 190.0),
    );
  }

  String _getTextBtn() {
    if (_isDragging) {
      return 'Like';
    }
    switch (_emojiUserChoose) {
      case ReactionEmoji.nothing:
        return 'Like';
      case ReactionEmoji.like:
        return 'Like';
      case ReactionEmoji.love:
        return 'Love';
      case ReactionEmoji.haha:
        return 'Haha';
      case ReactionEmoji.wow:
        return 'Wow';
      case ReactionEmoji.sad:
        return 'Sad';
      case ReactionEmoji.angry:
        return 'Angry';
    }
  }

  Color _getColorTextBtn() {
    if ((!_isLongPress && _isLiked)) {
      return Color(0xff3b5998);
    } else if (!_isDragging) {
      switch (_emojiUserChoose) {
        case ReactionEmoji.nothing:
          return Colors.grey;
        case ReactionEmoji.like:
          return Color(0xff3b5998);
        case ReactionEmoji.love:
          return Color(0xffED5167);
        case ReactionEmoji.haha:
        case ReactionEmoji.wow:
        case ReactionEmoji.sad:
          return Color(0xffFFD96A);
        case ReactionEmoji.angry:
          return Color(0xffF6876B);
      }
    } else {
      return Colors.grey;
    }
  }

  String _getImageEmojiBtn() {
    if (!_isLongPress && _isLiked) {
      return AssetImages.icLikeFill;
    } else if (!_isDragging) {
      switch (_emojiUserChoose) {
        case ReactionEmoji.nothing:
          return AssetImages.icLike;
        case ReactionEmoji.like:
          return AssetImages.icLikeFill;
        case ReactionEmoji.love:
          return AssetImages.icLove2;
        case ReactionEmoji.haha:
          return AssetImages.icHaha2;
        case ReactionEmoji.wow:
          return AssetImages.icWow2;
        case ReactionEmoji.sad:
          return AssetImages.icSad2;
        case ReactionEmoji.angry:
          return AssetImages.icAngry2;
      }
    } else {
      return AssetImages.icLike;
    }
  }

  Color? _getTintColorEmojiBtn() {
    if (!_isLongPress && _isLiked) {
      return Color(0xff3b5998);
    } else if (!_isDragging && _emojiUserChoose != ReactionEmoji.nothing) {
      return null;
    } else {
      return Colors.grey;
    }
  }

  double _processTopPosition(double value) {
    // margin top 100 -> 40 -> 160 (value from 180 -> 0)
    if (value >= 120.0) {
      return value - 80.0;
    } else {
      return 160.0 - value;
    }
  }

  Color _getColorBorderBtn() {
    if ((!_isLongPress && _isLiked)) {
      return Color(0xff3b5998);
    } else if (!_isDragging) {
      switch (_emojiUserChoose) {
        case ReactionEmoji.nothing:
          return Colors.grey;
        case ReactionEmoji.like:
          return Color(0xff3b5998);
        case ReactionEmoji.love:
          return Color(0xffED5167);
        case ReactionEmoji.haha:
        case ReactionEmoji.wow:
        case ReactionEmoji.sad:
          return Color(0xffFFD96A);
        case ReactionEmoji.angry:
          return Color(0xffF6876B);
      }
    } else {
      return Colors.grey.shade400;
    }
  }

  void _onHorizontalDragEndBoxEmoji(DragEndDetails dragEndDetail) {
    _isDragging = false;
    _isDraggingOutside = false;
    _isJustDragInside = true;
    _previousEmojiFocus = ReactionEmoji.nothing;
    _currentEmojiFocus = ReactionEmoji.nothing;

    _onTapUpBtn(null);
  }

  void _onHorizontalDragUpdateBoxEmoji(DragUpdateDetails dragUpdateDetail) {
    // return if the drag is drag without press button
    if (!_isLongPress) return;

    // the margin top the box is 150
    // and plus the height of toolbar and the status bar
    // so the range we check is about 200 -> 500

    if (dragUpdateDetail.globalPosition.dy >= 200 && dragUpdateDetail.globalPosition.dy <= 500) {
      _isDragging = true;
      _isDraggingOutside = false;

      if (_isJustDragInside && !_animControlEmojiWhenDragInside.isAnimating) {
        _animControlEmojiWhenDragInside.reset();
        _animControlEmojiWhenDragInside.forward();
      }

      if (dragUpdateDetail.globalPosition.dx >= 20 && dragUpdateDetail.globalPosition.dx < 83) {
        if (_currentEmojiFocus != ReactionEmoji.like) {
          _handleWhenDragBetweenEmoji(ReactionEmoji.like);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 83 && dragUpdateDetail.globalPosition.dx < 126) {
        if (_currentEmojiFocus != ReactionEmoji.love) {
          _handleWhenDragBetweenEmoji(ReactionEmoji.love);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 126 && dragUpdateDetail.globalPosition.dx < 180) {
        if (_currentEmojiFocus != ReactionEmoji.haha) {
          _handleWhenDragBetweenEmoji(ReactionEmoji.haha);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 180 && dragUpdateDetail.globalPosition.dx < 233) {
        if (_currentEmojiFocus != ReactionEmoji.wow) {
          _handleWhenDragBetweenEmoji(ReactionEmoji.wow);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 233 && dragUpdateDetail.globalPosition.dx < 286) {
        if (_currentEmojiFocus != ReactionEmoji.sad) {
          _handleWhenDragBetweenEmoji(ReactionEmoji.sad);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 286 && dragUpdateDetail.globalPosition.dx < 340) {
        if (_currentEmojiFocus != ReactionEmoji.angry) {
          _handleWhenDragBetweenEmoji(ReactionEmoji.angry);
        }
      }
    } else {
      _emojiUserChoose = ReactionEmoji.nothing;
      _previousEmojiFocus = ReactionEmoji.nothing;
      _currentEmojiFocus = ReactionEmoji.nothing;
      _isJustDragInside = true;

      if (_isDragging && !_isDraggingOutside) {
        _isDragging = false;
        _isDraggingOutside = true;
        _animControlEmojiWhenDragOutside.reset();
        _animControlEmojiWhenDragOutside.forward();
        _animControlBoxWhenDragOutside.reset();
        _animControlBoxWhenDragOutside.forward();
      }
    }
  }

  void _handleWhenDragBetweenEmoji(ReactionEmoji currentEmoji) {
    _playSound(AssetSounds.focus);
    _emojiUserChoose = currentEmoji;
    _previousEmojiFocus = _currentEmojiFocus;
    _currentEmojiFocus = currentEmoji;
    _animControlEmojiWhenDrag.reset();
    _animControlEmojiWhenDrag.forward();
  }

  void _onTapDownBtn(TapDownDetails tapDownDetail) {
    _holdTimer = Timer(_durationLongPress, _showBox);
  }

  void _onTapUpBtn(TapUpDetails? tapUpDetail) {
    if (_isLongPress) {
      if (_emojiUserChoose == ReactionEmoji.nothing) {
        _playSound(AssetSounds.boxDown);
      } else {
        _playSound(AssetSounds.pick);
      }
    }

    Timer(Duration(milliseconds: _durationAnimationBox), () {
      _isLongPress = false;
    });

    _holdTimer.cancel();

    _animControlBtnLongPress.reverse();

    setReverseValue();
    _animControlBox.reverse();

    _animControlEmojiWhenRelease.reset();
    _animControlEmojiWhenRelease.forward();
  }

  // when user short press the button
  void _onTapBtn() {
    if (!_isLongPress) {
      if (_emojiUserChoose == ReactionEmoji.nothing) {
        _isLiked = !_isLiked;
      } else {
        _emojiUserChoose = ReactionEmoji.nothing;
      }
      if (_isLiked) {
        _playSound(AssetSounds.shortPressLike);
        _animControlBtnShortPress.forward();
      } else {
        _animControlBtnShortPress.reverse();
      }
    }
  }

  double _handleOutputRangeZoomInEmojiLike(double value) {
    if (value >= 0.8) {
      return value;
    } else if (value >= 0.4) {
      return 1.6 - value;
    } else {
      return 0.8 + value;
    }
  }

  double _handleOutputRangeTiltEmojiLike(double value) {
    if (value <= 0.2) {
      return value;
    } else if (value <= 0.6) {
      return 0.4 - value;
    } else {
      return -(0.8 - value);
    }
  }

  void _showBox() {
    _playSound(AssetSounds.boxUp);
    _isLongPress = true;

    _animControlBtnLongPress.forward();

    _setForwardValue();
    _animControlBox.forward();
  }

  // We need to set the value for reverse because if not
  // the angry-emoji will be pulled down first, not the like-emoji
  void setReverseValue() {
    // Emojis
    _pushEmojiLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.5, 1.0)),
    );
    _zoomEmojiLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.5, 1.0)),
    );

    _pushEmojiLoveUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.4, 0.9)),
    );
    _zoomEmojiLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.4, 0.9)),
    );

    _pushEmojiHahaUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.3, 0.8)),
    );
    _zoomEmojiHaha = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.3, 0.8)),
    );

    _pushEmojiWowUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.2, 0.7)),
    );
    _zoomEmojiWow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.2, 0.7)),
    );

    _pushEmojiSadUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.1, 0.6)),
    );
    _zoomEmojiSad = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.1, 0.6)),
    );

    _pushEmojiAngryUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.0, 0.5)),
    );
    _zoomEmojiAngry = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.0, 0.5)),
    );
  }

  // When set the reverse value, we need set value to normal for the forward
  void _setForwardValue() {
    // Emojis
    _pushEmojiLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.0, 0.5)),
    );
    _zoomEmojiLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.0, 0.5)),
    );

    _pushEmojiLoveUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.1, 0.6)),
    );
    _zoomEmojiLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.1, 0.6)),
    );

    _pushEmojiHahaUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.2, 0.7)),
    );
    _zoomEmojiHaha = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.2, 0.7)),
    );

    _pushEmojiWowUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.3, 0.8)),
    );
    _zoomEmojiWow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.3, 0.8)),
    );

    _pushEmojiSadUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.4, 0.9)),
    );
    _zoomEmojiSad = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.4, 0.9)),
    );

    _pushEmojiAngryUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.5, 1.0)),
    );
    _zoomEmojiAngry = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animControlBox, curve: Interval(0.5, 1.0)),
    );
  }

  Future<void> _playSound(String nameSound) async {
    // Sometimes multiple sound will play the same time, so we'll stop all before play the newest
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(nameSound));
  }
}
