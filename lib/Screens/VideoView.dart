import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewPage extends StatefulWidget {
  const VideoViewPage({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  _VideoViewPageState createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {}); // Refresh to show first frame
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: const [
          IconButton(
            icon: Icon(Icons.crop_rotate, size: 27),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.emoji_emotions_outlined, size: 27),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.title, size: 27),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 27),
            onPressed: null,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_controller.value.isInitialized)
            SizedBox(
              width: mediaSize.width,
              height: mediaSize.height - 150,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          Positioned(
            bottom: 0,
            child: Container(
              width: mediaSize.width,
              color: Colors.black38,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
                maxLines: 6,
                minLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Add Caption....",
                  prefixIcon: const Icon(
                    Icons.add_photo_alternate,
                    color: Colors.white,
                    size: 27,
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  suffixIcon: CircleAvatar(
                    radius: 27,
                    backgroundColor: Colors.tealAccent[700],
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: CircleAvatar(
                radius: 33,
                backgroundColor: Colors.black38,
                child: Icon(
                  _controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
