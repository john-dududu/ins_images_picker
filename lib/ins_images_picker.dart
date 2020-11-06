import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class InsImagesPicker {
  static const MethodChannel _channel =
      const MethodChannel('ins_images_picker');

  static const int image = 0;
  static const int video = 1;

  static Future<List<File>> showPicker({
    @required int maxImages,
    @required int mediaType,
    @required List<String> ratios,
    @required String appName,
    @required String navigationBarColor,
    @required String navigationBarItemColor,
    double quality = 1.0
  }) async {
    try {
      final List<dynamic> images = await _channel.invokeMethod(
          'pickerImages', <String, dynamic>{
        "maxImages": maxImages,
        "mediaType": mediaType,
        "ratios": ratios,
        "appName": appName,
        "navigationBarColor": navigationBarColor,
        "navigationBarItemColor": navigationBarItemColor,
        "quality": quality
      });
      return images.map((f) {
        return File(f["path"]);
      }).toList();
    } catch (e) {
      print(e);
      return List<File>();
    }
  }
}
