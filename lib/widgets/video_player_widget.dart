import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../app_tab/utils/colors.dart';

/// Reusable video player widget that supports YouTube URLs using IFrame (Best for Web)
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

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    final videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);
    
    double? startSeconds;
    double? endSeconds;

    try {
      final uri = Uri.tryParse(widget.videoUrl);
      if (uri != null) {
        if (uri.queryParameters.containsKey('start')) {
          startSeconds = double.tryParse(uri.queryParameters['start']!);
        }
        if (uri.queryParameters.containsKey('end')) {
          endSeconds = double.tryParse(uri.queryParameters['end']!);
        }
      }
    } catch (_) {}

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
      startSeconds: startSeconds,
      endSeconds: endSeconds,
      params: const YoutubePlayerParams(
        mute: true,
        showControls: true,
        showFullscreenButton: true,
        enableJavaScript: true,
      ),
    );
    
    debugPrint('🎬 WebView IFrame initialized with ID: $videoId from URL: ${widget.videoUrl} (start: $startSeconds, end: $endSeconds)');
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);
    
    if (videoId == null) {
      return Center(
        child: Text(
          'Invalid YouTube URL\n${widget.videoUrl}',
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }

    return YoutubePlayer(
      key: ValueKey(videoId), // Force refresh when ID changes
      controller: _controller,
      aspectRatio: 16 / 9,
    );
  }
}
