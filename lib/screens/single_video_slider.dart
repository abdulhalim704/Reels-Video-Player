// Single Video Slider
// ignore_for_file: deprecated_member_use

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SingleVideoContentScreen extends StatefulWidget {
  final Map<String, String> videos;

  const SingleVideoContentScreen({super.key, required this.videos});

  @override
  ContentScreenState createState() => ContentScreenState();
}

class ContentScreenState extends State<SingleVideoContentScreen> {
  late List<VideoPlayerController> _videoControllers;
  late int _currentSegmentIndex;
  late ChewieController _chewieController;
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _currentSegmentIndex = 0;
    _sliderValue = 0.0;
    _initializeVideoControllers();
  }

  Future<void> _initializeVideoControllers() async {
    _videoControllers = [];
    for (final entry in widget.videos.entries) {
      final controller = VideoPlayerController.network(entry.value);
      await controller.initialize();
      _videoControllers.add(controller);
    }
    _initializeChewieController();
  }

  @override
  void dispose() {
    for (final controller in _videoControllers) {
      controller.dispose();
    }
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Chewie(controller: _chewieController),
          const Positioned(top: 50, left: 20, child: Icon(Icons.menu)),
          const Positioned(top: 50, right: 20, child: Icon(Icons.person)),
          if (widget.videos.isNotEmpty) _buildTimelineScroller(),
        ],
      ),
    );
  }

  void _initializeChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoControllers[_currentSegmentIndex],
      autoPlay: true,
      looping: false,
      aspectRatio: 0.48,
      showControls: false,
      allowedScreenSleep: false,
      allowFullScreen: false,
    );
    _chewieController.videoPlayerController
        .addListener(_onVideoPlayerStateChanged);
  }

  void _onVideoPlayerStateChanged() {
    final videoPosition =
        _chewieController.videoPlayerController.value.position;
    final videoDuration =
        _chewieController.videoPlayerController.value.duration;
    setState(() {
      _sliderValue = videoPosition.inSeconds.toDouble();
    });
    if (videoPosition >= videoDuration) {
      if (_currentSegmentIndex < widget.videos.length - 1) {
        setState(() {
          _currentSegmentIndex++;
          _initializeChewieController();
        });
      } else {
        // All videos played
        // You can handle this scenario as needed
      }
    }
  }

  Widget _buildTimelineScroller() {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Column(
        children: [
          Slider(
            value: _sliderValue,
            min: 0,
            max: _chewieController
                .videoPlayerController.value.duration.inSeconds
                .toDouble(),
            onChanged: (value) {
              final newPosition = Duration(seconds: value.toInt());
              _chewieController.videoPlayerController.seekTo(newPosition);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.videos.keys.map((key) {
              final index = widget.videos.keys.toList().indexOf(key);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentSegmentIndex = index;
                    _initializeChewieController();
                  });
                },
                child: Text(
                  key,
                  style: TextStyle(
                    color: _currentSegmentIndex == index
                        ? Colors.blue
                        : Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
