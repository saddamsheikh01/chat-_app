import 'dart:math';
import 'package:camera/camera.dart';
import 'package:chatapp/Screens/CameraView.dart';
import 'package:chatapp/Screens/VideoView.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> cameras;

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  bool isRecording = false;
  bool flash = false;
  bool isCameraFront = true;
  double transform = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera(isCameraFront ? 0 : 1);
  }

  Future<void> _initializeCamera(int cameraIndex) async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }

    final controller = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.high,
    );

    _initializeControllerFuture = controller.initialize();
    _cameraController = controller;

    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && _cameraController != null) {
                return CameraPreview(_cameraController!);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          flash ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () async {
                          if (_cameraController == null) return;
                          flash = !flash;
                          setState(() {});
                          await _cameraController!.setFlashMode(
                            flash ? FlashMode.torch : FlashMode.off,
                          );
                        },
                      ),
                      GestureDetector(
                        onLongPress: () async {
                          if (_cameraController == null || isRecording) return;
                          await _cameraController!.startVideoRecording();
                          setState(() => isRecording = true);
                        },
                        onLongPressUp: () async {
                          if (_cameraController == null || !isRecording) return;
                          final videoFile = await _cameraController!.stopVideoRecording();
                          setState(() => isRecording = false);

                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoViewPage(path: videoFile.path),
                            ),
                          );
                        },
                        onTap: () {
                          if (!isRecording) takePhoto(context);
                        },
                        child: Icon(
                          isRecording ? Icons.radio_button_on : Icons.panorama_fish_eye,
                          color: isRecording ? Colors.red : Colors.white,
                          size: isRecording ? 80 : 70,
                        ),
                      ),
                      IconButton(
                        icon: Transform.rotate(
                          angle: transform,
                          child: const Icon(
                            Icons.flip_camera_ios,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        onPressed: () async {
                          isCameraFront = !isCameraFront;
                          transform += pi;
                          setState(() {});
                          await _initializeCamera(isCameraFront ? 0 : 1);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Hold for video, tap for photo",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> takePhoto(BuildContext context) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    final file = await _cameraController!.takePicture();
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraViewPage(path: file.path),
      ),
    );
  }
}
