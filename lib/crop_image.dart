import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:imagefromcam_storage/home_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crop_your_image/crop_your_image.dart';

class ImageCropper extends StatefulWidget {
  final Uint8List imageToBeCropped;

  const ImageCropper({
    super.key,
    required this.imageToBeCropped,
  });

  @override
  State<ImageCropper> createState() => _ImageCropperState();
}

class _ImageCropperState extends State<ImageCropper> {
  final CropController cropperController = CropController();

  Future<void> onButtonTap() async {
    cropperController.crop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: onButtonTap),
      body: Crop(
        controller: cropperController,
        image: widget.imageToBeCropped,
        onCropped: (croppedImage) async {
          try {
            final directory = await getApplicationDocumentsDirectory();
            String fileName =
                'cropped_image_${DateTime.now().millisecondsSinceEpoch}.png';
            String filePath = '${directory.path}/$fileName';

            File file = File(filePath);
            await file.writeAsBytes(croppedImage);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Image saved to: $filePath')),
            );

            print('Image saved to: $filePath');

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                fileName: filePath,
              ),
            ));
          } catch (e) {
            print('Error saving image: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error saving image')),
            );
          }
        },
      ),
    );
  }
}
