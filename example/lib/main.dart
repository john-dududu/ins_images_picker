import 'package:flutter/material.dart';
import 'dart:io';

import 'package:ins_images_picker/ins_images_picker.dart';
import 'package:ins_images_picker_example/video.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<File> _images = new List<File>();
  List<File> _videos = new List<File>();

  @override
  void initState() {
    super.initState();
  }

  void showPhotoCamera() async {
    List<File> images = await InsImagesPicker.showPicker(
        maxImages: 1,
        screenType: 0,
        ratios: ['1:1', '3:4', '16:9'],
        appName: "Influencer",
        navigationBarColor: Colors.blue,
        navigationBarItemColor: Colors.white,
        backgroundColor: Colors.grey,
        statusBarStyleValue: 1,
        quality: 0.8,
        videoQuality: 'AVAssetExportPreset1280x720',
        trimVideo: false);
    if (images != null && images.isNotEmpty) {
      images.forEach((element) {
        _images.add(element);
      });
      setState(() {});
    } else {
      print(images);
    }
  }

  void showVideoCamera() async {
    List<File> images = await InsImagesPicker.showPicker(
        maxImages: 1,
        screenType: 1,
        ratios: ['1:1', '3:4', '16:9'],
        appName: "Influencer",
        navigationBarColor: Colors.blue,
        navigationBarItemColor: Colors.white,
        backgroundColor: Colors.grey,
        statusBarStyleValue: 1,
        quality: 0.8,
        videoQuality: 'AVAssetExportPreset1280x720',
        trimVideo: true);
    if (images != null && images.isNotEmpty) {
      images.forEach((element) {
        _images.add(element);
      });
      setState(() {});
    } else {
      print(images);
    }
  }

  void showImagePicker() async {
    List<File> images = await InsImagesPicker.showPicker(
        maxImages: 1,
        screenType: 2,
        ratios: ['1:1', '3:4', '16:9'],
        appName: "Influencer",
        navigationBarColor: Colors.blue,
        navigationBarItemColor: Colors.white,
        backgroundColor: Colors.grey,
        statusBarStyleValue: 1,
        quality: 0.8,
        videoQuality: 'AVAssetExportPreset1280x720',
        trimVideo: false);
    if (images != null && images.isNotEmpty) {
      images.forEach((element) {
        _images.add(element);
      });
      setState(() {});
    } else {
      print(images);
    }
  }

  void showVideoPicker() async {
    List<File> videos = await InsImagesPicker.showPicker(
        maxImages: 1,
        screenType: 3,
        ratios: ['1:1', '3:4', '16:9'],
        appName: "Influencer",
        navigationBarColor: Colors.blue,
        navigationBarItemColor: Colors.white,
        backgroundColor: Colors.grey,
        statusBarStyleValue: 1,
        quality: 0.8,
        videoQuality: 'AVAssetExportPreset1280x720',
        trimVideo: true);
    if (videos != null && videos.isNotEmpty) {
      videos.forEach((element) {
        _videos.add(element);
      });
      setState(() {});
    } else {
      print(_videos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text(
          'Picker Example App',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
      body: Container(
          child: Column(
        children: [
          MaterialButton(
            onPressed: showPhotoCamera,
            child: Text("TAKE PHOTO",
                style: TextStyle(
                  color: Colors.white,
                )),
            color: Colors.red,
          ),
          MaterialButton(
            onPressed: showVideoCamera,
            child: Text("RECORD A VIDEO",
                style: TextStyle(
                  color: Colors.white,
                )),
            color: Colors.red,
          ),
          MaterialButton(
            onPressed: showImagePicker,
            child: Text("IMPORT IMAGE",
                style: TextStyle(
                  color: Colors.white,
                )),
            color: Colors.blue,
          ),
          MaterialButton(
            onPressed: showVideoPicker,
            child: Text("IMPORT VIDEO",
                style: TextStyle(
                  color: Colors.white,
                )),
            color: Colors.blue,
          ),
          ListView.builder(
              itemCount: _images?.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Image.file(
                    _images.elementAt(index),
                    height: 100,
                    width: 100,
                  ),
                );
              }),
          ListView.builder(
              itemCount: _videos?.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: VideoApp(_videos.elementAt(index)),
                );
              })
        ],
      )),
    ));
  }
}
