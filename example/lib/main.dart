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

  void showImagePicker() async {
    List<File> images = await InsImagesPicker.showPicker(
        maxImages: 1, mediaType: 0,
        ratios: ["1:1", "4:3", "16:9"],
        appName: "Influencer",
        navigationBarColor: "#F7512D",
        navigationBarItemColor: "#2DD2F7",
        quality: 0.8);
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
        maxImages: 1, quality: 0.8, mediaType: 1);
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
        body: Container(child: Column(
          children: [
            MaterialButton(
              onPressed: showImagePicker,
              child: Text("IMAGE",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              color: Colors.blue,
            ),
            MaterialButton(
              onPressed: showVideoPicker,
              child: Text("VIDEO",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              color: Colors.red,
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
        )),)
    );
  }
}
