import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../constants/color_res.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String url;

  const CustomVideoPlayer({super.key, required this.url});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideo;
  bool _isPlaying = false;

  void _startVideo() {
    setState(() {
      _controller = VideoPlayerController.network(widget.url);
      _initializeVideo = _controller!.initialize().then((_) {
        _controller!.setLooping(true);
        _controller!.play();
        setState(() => _isPlaying = true);
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      // Initial state — show thumbnail/play button
      return GestureDetector(
        onTap: _startVideo,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: ColorRes.black,
              width: double.infinity,
              height: double.infinity,
              child:  Center(
                child: Icon(Icons.videocam, color: ColorRes.white.withOpacity(0.9), size: 48),
              ),
            ),
            const CircleAvatar(
              backgroundColor: ColorRes.textPrimary,
              radius: 28,
              child: Icon(Icons.play_arrow, color: ColorRes.white, size: 36),
            ),
          ],
        ),
      );
    }

    // Video mode
    return FutureBuilder(
      future: _initializeVideo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            _controller!.value.isInitialized) {
          return AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
