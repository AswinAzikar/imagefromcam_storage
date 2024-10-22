import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera_universal/camera_universal.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:imagefromcam_storage/crop_image.dart';

import 'package:path_provider/path_provider.dart';

import 'package:crop_image/crop_image.dart';

class CameraFile extends StatefulWidget {
  const CameraFile({super.key});

  @override
  State<CameraFile> createState() => _CameraFileState();
}

class _CameraFileState extends State<CameraFile> {
  CameraController cameraController = CameraController();
  final CropController cropController = CropController(
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  @override
  void initState() {
    super.initState();
    task();
  }

  Future<void> task() async {
    await cameraController.initializeCameras();
    await cameraController.initializeCamera(
      setState: setState,
    );
    await cameraController.activateCamera(
      setState: setState,
      mounted: () {
        return mounted;
      },
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> captureImage() async {
    try {
      final CameraTakePictureData? imageData =
          await cameraController.action_take_picture(
        onCameraNotInit: () {},
        onCameraNotSelect: () {
          //   logError("ERROR: Camera not selected.");
        },
        onCameraNotActive: () {
//logError("ERROR: Camera not active.");
        },
      );

      if (imageData == null) {
        print('Image capture failed.');
        return;
      }

      final imagePath = imageData.path;
      await processImage(imagePath);
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await processImage(image.path);
    } else {
      print('Image selection cancelled or failed.');
    }
  }

  Future<void> processImage(String imagePath) async {
    try {
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final img.Image? decodedImage = img.decodeImage(imageBytes);

      if (decodedImage == null) {
        print('Error decoding image.');
        return;
      }

      final img.Image flippedImage = img.flipHorizontal(decodedImage);
      final Uint8List flippedImageBytes =
          Uint8List.fromList(img.encodePng(flippedImage));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageCropper(
            imageToBeCropped: flippedImageBytes,
          ),
        ),
      );

      print('Flipped image passed to ImageCropper');
    } catch (e) {
      print('Error processing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ))
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Camera(
        cameraController: cameraController,
        onCameraNotInit: (context) {
          return const SizedBox.shrink();
        },
        onCameraNotSelect: (context) {
          return const SizedBox.shrink();
        },
        onCameraNotActive: (context) {
          return const SizedBox.shrink();
        },
        onPlatformNotSupported: (context) {
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await captureImage();
            },
            child: const Icon(
              Icons.camera_alt,
            ),
          ),
          FloatingActionButton(
            onPressed: () async {
              await pickImageFromGallery();
            },
            child: const Icon(
              Icons.photo_library,
            ),
          ),
        ],
      ),
    );
  }
}
