import 'dart:io';
import 'package:flutter/material.dart';

class CameraViewPage extends StatelessWidget {
  const CameraViewPage({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.crop_rotate, size: 27),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined, size: 27),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.title, size: 27),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 27),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height - 150,
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              color: Colors.black38,
              width: size.width,
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
                  hintText: "Add Caption...",
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
                    radius: 24,
                    backgroundColor: Colors.tealAccent[700],
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
