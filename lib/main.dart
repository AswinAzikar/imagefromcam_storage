// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print, unused_import, dead_code, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera_universal/camera_universal.dart';
import 'package:crop_image/crop_image.dart';
import 'package:imagefromcam_storage/home_screen.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      home: HomeScreen(),
    ),
  );
}
