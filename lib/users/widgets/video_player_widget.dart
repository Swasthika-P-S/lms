import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Reusable video player widget that supports YouTube URLs
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.autoPlay = false,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    // Extract video ID from YouTube URL
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    
    if (videoId == null) {
      print('❌ Invalid YouTube URL: ${widget.videoUrl}');
      return;
    }

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoPlay,
        mute: false,
        enableCaption: true,
        controlsVisibleAtStart: true,
        hideControls: false,
        loop: false,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        // Handle fullscreen enter
      },
      onExitFullScreen: () {
        // Handle fullscreen exit
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Theme.of(context).primaryColor,
        progressColors: ProgressBarColors(
          playedColor: Theme.of(context).primaryColor,
          handleColor: Theme.of(context).primaryColor,
          bufferedColor: Colors.grey,
          backgroundColor: Colors.grey.shade300,
        ),
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          // Handle video end
          print('✅ Video ended');
        },
      ),
      builder: (context, player) {
        return Column(
          children: [
            player,
            // Additional controls can be added here
          ],
        );
      },
    );
  }
}
