import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';

class SliderBar extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const SliderBar(
      {required audioPlayer,
      required this.duration,
      required this.position,
      required this.bufferedPosition})
      : _audioPlayer = audioPlayer;

  final AudioPlayer _audioPlayer;
  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;
  @override
  _SliderBarState createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  String formatDur(Duration d) {
    return (d.toString().split('.').first.padLeft(7, '0'));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Slider(
            activeColor: Colors.grey[600],
            inactiveColor: Colors.grey[300],
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                widget._audioPlayer.seek(Duration(milliseconds: value.round()));
              });
            }),
      ),
      Positioned(left: 16, bottom: 0, child: Text(formatDur(widget.position))),
      Positioned(right: 16, bottom: 0, child: Text(formatDur(widget.duration)))
    ]);
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
