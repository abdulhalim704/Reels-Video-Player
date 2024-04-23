//this code is running with our logic
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ContentScreen extends StatefulWidget {
  final Map<String, String> videos;

  const ContentScreen({super.key, required this.videos});

  @override
  ContentScreenState createState() => ContentScreenState();
}

class ContentScreenState extends State<ContentScreen> {
  VideoPlayerController _videoController = VideoPlayerController.asset('');
  List<VideoPlayerController> _videoControllers = [];
  int _currentSegmentIndex = 0;
  Duration _totalDuration = Duration.zero;
  Duration _sliderValue = Duration.zero;

  @override
  void initState() {
    super.initState();
    _currentSegmentIndex = 0;
    _initializeVideoControllers();
  }

  Future<void> _initializeVideoControllers() async {
    _videoControllers = [];
    _totalDuration = Duration.zero;

    for (final entry in widget.videos.entries) {
      final controller = VideoPlayerController.network(entry.value);
      await controller.initialize();
      _totalDuration += controller.value.duration;
      _videoControllers.add(controller);
    }

    _videoController = _videoControllers[_currentSegmentIndex];
    _videoController.addListener(_onVideoPlayerStateChanged);
    _videoController.play();

    setState(() {}); // Trigger rebuild after initialization
  }

  @override
  void dispose() {
    _videoController.dispose();
    for (final controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onVideoPlayerStateChanged() {
    final videoPosition = _videoController.value.position;
    if (videoPosition >= _videoController.value.duration) {
      if (_currentSegmentIndex < widget.videos.length - 1) {
        setState(() {
          _currentSegmentIndex++;
          _videoController.removeListener(_onVideoPlayerStateChanged);
          _videoController = _videoControllers[_currentSegmentIndex];
          _videoController.addListener(_onVideoPlayerStateChanged);
          _videoController.play();
        });
      } else {
        // All videos played
        // You can handle this scenario as needed
      }
    }
    // i am chaange only this point
    setState(() {
      _sliderValue = _calculateSliderValue(_videoController.value.position);
    });
  }

  Duration _calculateSliderValue(Duration videoPosition) {
    Duration totalPosition = Duration.zero;
    for (int i = 0; i < _currentSegmentIndex; i++) {
      totalPosition += _videoControllers[i].value.duration;
    }
    return totalPosition + videoPosition;
  }

  Widget _buildTimelineScroller() {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Column(
        children: [
          Slider(
            value: _sliderValue.inSeconds.toDouble(),
            min: 0,
            max: _totalDuration.inSeconds.toDouble(),
            onChanged: (value) {
              final newSliderValue = Duration(seconds: value.toInt());
              _seekToPosition(newSliderValue);
            },
            activeColor: Colors.blue,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.videos.keys.map((key) {
              final index = widget.videos.keys.toList().indexOf(key);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentSegmentIndex = index;
                    _videoController.removeListener(_onVideoPlayerStateChanged);
                    _videoController = _videoControllers[_currentSegmentIndex];
                    _videoController.addListener(_onVideoPlayerStateChanged);
                    _videoController.play();
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

  void _seekToPosition(Duration newPosition) {
    Duration totalDuration = Duration.zero;
    int i = 0;
    for (final controller in _videoControllers) {
      totalDuration += controller.value.duration;
      if (newPosition <= totalDuration) {
        final remainingDuration =
            newPosition - (totalDuration + controller.value.duration);
        _currentSegmentIndex = i;
        _videoController.removeListener(_onVideoPlayerStateChanged);
        _videoController = _videoControllers[_currentSegmentIndex];
        _videoController.addListener(_onVideoPlayerStateChanged);
        _videoController.seekTo(remainingDuration);
        _videoController.play();
        break;
      }
      i++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_videoController.value.isInitialized)
            AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            )
          else
            const Center(child: CircularProgressIndicator()),
          const Positioned(top: 50, left: 20, child: Icon(Icons.menu)),
          const Positioned(top: 50, right: 20, child: Icon(Icons.person)),
          if (widget.videos.isNotEmpty) _buildTimelineScroller(),
        ],
      ),
    );
  }
}
