import 'package:flutter/material.dart';
import 'content_screen.dart';

class HomePage extends StatelessWidget {
  // final List<String> videos = [
  // 'https://assets.mixkit.co/videos/preview/mixkit-taking-photos-from-different-angles-of-a-model-34421-large.mp4',
  // 'https://assets.mixkit.co/videos/preview/mixkit-young-mother-with-her-little-daughter-decorating-a-christmas-tree-39745-large.mp4',
  // 'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
  // 'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4',
  // 'https://assets.mixkit.co/videos/preview/mixkit-winter-fashion-cold-looking-woman-concept-video-39874-large.mp4',
  // 'https://assets.mixkit.co/videos/preview/mixkit-womans-feet-splashing-in-the-pool-1261-large.mp4',
  // 'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4'
  // ];

  final Map<String, String> videos = {
    '1920':
        ' https://assets.mixkit.co/videos/preview/mixkit-black-background-with-smoke-foreground-1968-large.mp4',
    '1968':
        'https://assets.mixkit.co/videos/preview/mixkit-young-photographer-setting-up-his-camera-outdoors-34408-large.mp4',
    '1950':
        'https://assets.mixkit.co/videos/preview/mixkit-young-mother-with-her-little-daughter-decorating-a-christmas-tree-39745-large.mp4',
    '1975':
        'https://assets.mixkit.co/videos/preview/mixkit-under-a-peripheral-road-with-two-avenues-on-the-sides-34560-large.mp4',
    '1982':
        'https://assets.mixkit.co/videos/preview/mixkit-city-traffic-on-bridges-and-streets-34565-large.mp4',
  };

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentScreen(videos: videos),

      // body: Swiper(
      //   itemBuilder: (BuildContext context, int index) {
      //     return ContentScreen(
      //       src: videos[index],
      //     );
      //   },
      //   itemCount: videos.length,
      //   scrollDirection: Axis.vertical,
      // ),
    );
  }
}
