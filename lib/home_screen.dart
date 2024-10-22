import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:imagefromcam_storage/camera_file.dart';

class HomeScreen extends StatefulWidget {
  final String? fileName;

  const HomeScreen({super.key, this.fileName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CameraFile(),
                  )),
                  child: Container(
                    color: Colors.grey,
                    width: 70,
                    height: 50,
                    child: const Center(child: Text(" Select Image : ")),
                  ),
                ),
                Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(widget.fileName != null ? widget.fileName! : ""),
                ),
                widget.fileName != null
                    ? OpenContainer(
                        closedElevation: 0,
                        closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        closedBuilder: (context, action) {
                          return Image.file(
                            File(widget.fileName!),
                            width: 40,
                            height: 40,
                            scale: .3,
                          );
                        },
                        openBuilder: (context, action) {
                          return Scaffold(
                            appBar: AppBar(
                              title: const Text('Image Viewer'),
                              backgroundColor: Colors.white,
                              actions: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                            body: Center(
                              child: Image.file(
                                File(widget.fileName!),
                                fit: BoxFit.contain, // Adjusts the image size
                                width: double.infinity, // Take full width
                                height: double.infinity, // Take full height
                              ),
                            ),
                          );
                        },
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
