import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:new_eventmatch/screens/home_page.dart';
import 'package:new_eventmatch/screens/profile_page.dart';
import 'package:new_eventmatch/screens/search_page.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({Key? key}) : super(key: key);

  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  int _selectedIndex = 2;
  late PageController _pageController;
  VideoPlayerController? _videoController;
  bool _isPlaying = false;
  bool _isLiked = false;

  final List<String> _videoUrls = [
    'videos/2361938-uhd_3840_2160_30fps.mp4',
    'videos/2941129-uhd_4096_2160_24fps.mp4',
    'videos/2890196-hd_1920_1080_30fps.mp4',
    'videos/2977213-hd_1920_1080_24fps.mp4',
    'videos/3049544-uhd_4096_2160_24fps.mp4',
    'videos/3195885-uhd_3840_2160_25fps.mp4',
    'videos/3577616-hd_1920_1080_30fps.mp4',
    'videos/3722010-hd_1920_1080_24fps.mp4',
    'videos/4916733-hd_1920_1080_30fps.mp4',
    'videos/2066560-hd_1920_1080_30fps.mp4',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeVideo(0);
  }

  Future<void> _initializeVideo(int index) async {
    if (_videoController != null) {
      await _videoController!.pause();
      await _videoController!.dispose();
    }

    _videoController = VideoPlayerController.asset(_videoUrls[index]);

    try {
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.play();

      setState(() {
        _isPlaying = true;
      });
      print("Video initialized successfully.");
    } catch (e) {
      print("Error initializing video: $e");
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const SearchPage()));
    } else if (index == 3) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const ProfilePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Videos'), centerTitle: true),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _videoUrls.length,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          _initializeVideo(index);
        },
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Positioned.fill(
                child: (_videoController != null &&
                        _videoController!.value.isInitialized)
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoController!.value.size.width,
                          height: _videoController!.value.size.height,
                          child: VideoPlayer(_videoController!),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_isPlaying) {
                            _videoController?.pause();
                          } else {
                            _videoController?.play();
                          }
                          _isPlaying = !_isPlaying;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.red : Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          _isLiked = !_isLiked;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.comment, color: Colors.white, size: 30),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined), label: 'Videos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: 'Profile'),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
