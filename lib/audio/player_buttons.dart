import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButtons extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const PlayerButtons(this._audioPlayer, this.episodeSelected, this.context);
  final AudioPlayer _audioPlayer;
  final bool episodeSelected;
  final BuildContext context;

  void showSliderDialog({
    required BuildContext context,
    required String title,
    required int divisions,
    required double min,
    required double max,
    String valueSuffix = '',
    required double value,
    required Stream<double> stream,
    required ValueChanged<double> onChanged,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: StreamBuilder<double>(
          stream: stream,
          builder: (context, snapshot) => SizedBox(
            height: 100.0,
            child: Column(
              children: [
                Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                    style: const TextStyle(
                        fontFamily: 'Fixed',
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0)),
                Slider(
                  divisions: divisions,
                  min: min,
                  max: max,
                  value: snapshot.data ?? value,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: _audioPlayer.volume,
              stream: _audioPlayer.volumeStream,
              onChanged: _audioPlayer.setVolume,
            );
          },
        ),
        StreamBuilder<Duration>(
            stream: _audioPlayer.positionStream,
            builder: (_, snapshot) {
              final pos = snapshot.data;
              return IconButton(
                icon: const Icon(Icons.replay_30),
                onPressed: () async {
                  Duration seeking = pos! - const Duration(seconds: 30);
                  await _audioPlayer.seek(seeking);
                },
              );
            }),
        StreamBuilder<PlayerState>(
          stream: _audioPlayer.playerStateStream,
          builder: (_, snapshot) {
            final playerState = snapshot.data;
            return _playPauseButton(playerState);
          },
        ),
        StreamBuilder<Duration>(
            stream: _audioPlayer.positionStream,
            builder: (_, snapshot) {
              final pos = snapshot.data;
              return IconButton(
                onPressed: () async {
                  Duration seeking = pos! + const Duration(seconds: 30);
                  await _audioPlayer.seek(seeking);
                },
                icon: const Icon(Icons.forward_30),
              );
            })
      ],
    );
  }

  Widget _playPauseButton(PlayerState? playerState) {
    final processingState = playerState?.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      // print(playerState);
      return Container(
        margin: const EdgeInsets.all(8.0),
        width: 64.0,
        height: 64.0,
        child: const CircularProgressIndicator(),
      );
    } else if (_audioPlayer.playing != true) {
      // if (episodeSelected) {}
      return IconButton(
        icon: const Icon(Icons.play_arrow),
        iconSize: 64.0,
        onPressed: () {
          if (episodeSelected) {
            _audioPlayer.play();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(20.0),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.podcasts, size: 40.0, color: Colors.green),
                  Text(
                    'Select episode to play !',
                    style: TextStyle(fontSize: 24),
                  )
                ],
              ),
            ));
          }
        },
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        icon: const Icon(Icons.pause),
        iconSize: 64.0,
        onPressed: _audioPlayer.pause,
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.replay),
        iconSize: 64,
        onPressed: () => _audioPlayer.seek(Duration.zero,
            index: _audioPlayer.effectiveIndices?.first),
      );
    }
  }
}
