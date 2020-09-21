import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class InsImagesPicker {
  static const MethodChannel _channel =
      const MethodChannel('ins_images_picker');

  static Future<List<File>> showImagePicker({@required int maxImages}) async {
    try {
      final List<dynamic> images = await _channel.invokeMethod(
          'pickerImages', <String, dynamic>{"maxImages": maxImages});
      return images.map((f) {
        return File(f["path"]);
      }).toList();
    } catch (e) {
      print(e);
      return List<File>();
    }
  }
}
