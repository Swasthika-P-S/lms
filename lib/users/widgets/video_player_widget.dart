import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// Reusable video player widget that supports YouTube URLs using the IFrame API
class VideoPlayerWidget extends StatelessWidget {
  final YoutubePlayerController controller;
  final int startAt;
  final int? endAt;

  const VideoPlayerWidget({
    Key? key,
    required this.controller,
    this.startAt = 0,
    this.endAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        YoutubePlayer(
          controller: controller,
          aspectRatio: 16 / 9,
        ),
        _buildCustomControls(context),
      ],
    );
  }

  Widget _buildCustomControls(BuildContext context) {
    return StreamBuilder<YoutubeVideoState>(
      stream: controller.videoStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final currentPos = state?.position.inSeconds ?? 0;
        final start = startAt;
        
        // If endAt is not provided, fallback to 0 (we'd need metadata stream to get total length robustly, 
        // but since we always provide endAt for lessons, this is fine).
        int end = endAt ?? 0;
        final duration = end - start;
        if (duration <= 0) return const SizedBox.shrink();

        final adjustedPos = (currentPos - start).clamp(0, duration);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: Theme.of(context).cardColor,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.play_arrow, // Simple toggle visual fallback since we don't have isPlaying synchronous state easily in iframe
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () async {
                  final playerState = await controller.playerState;
                  if (playerState == PlayerState.playing) {
                    controller.pauseVideo();
                  } else {
                    controller.playVideo();
                  }
                },
              ),
              const SizedBox(width: 8),
              Text(
                _formatDuration(adjustedPos),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                  ),
                  child: Slider(
                    value: adjustedPos.toDouble(),
                    min: 0.0,
                    max: duration.toDouble(),
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Colors.grey.withOpacity(0.3),
                    onChanged: (newVal) {
                      controller.seekTo(seconds: (start + newVal).toDouble());
                    },
                  ),
                ),
              ),
              Text(
                _formatDuration(duration),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Icons.volume_up,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () async {
                  final isMuted = await controller.isMuted;
                  if (isMuted) {
                    controller.unMute();
                  } else {
                    controller.mute();
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.fullscreen,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  controller.toggleFullScreen();
                },
              )
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 0) seconds = 0;
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    if (min >= 60) {
      final hour = min ~/ 60;
      final remainingMin = min % 60;
      return '$hour:${remainingMin.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
    }
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}
