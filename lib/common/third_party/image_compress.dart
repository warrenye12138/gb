import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FImageCompress {
  ///压缩文件、返回Uint8List
  static Future<Uint8List?> compressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 720,
      minHeight: 480,
      quality: 50,
      rotate: 0,
    );
    return result;
  }

  ///压缩文件、返回文件
  static Future<XFile?> compressFileAndGetFile(File file, String targetPath,
      {String type = ""}) async {
    CompressFormat format = _getImageFormatType(type);
    try {
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        minWidth: 720,
        minHeight: 480,
        quality: 25,
        rotate: 0,
        format: format,
      );
      return result ?? XFile(file.path); //压缩成功，result可能为null
    } catch (e) {
      return null;
    }
  }

  static CompressFormat _getImageFormatType(String typeString) {
    if ([
      ".jpg",
      ".jpeg",
      ".jpe",
      ".jfif",
      ".jif",
      ".JPG",
      ".JPEG",
      ".JPE",
      ".JFIF",
      ".JIF"
    ].contains(typeString)) {
      return CompressFormat.jpeg;
    }
    if ([".png", ".PNG"].contains(typeString)) {
      return CompressFormat.png;
    }
    if ([".webp", ".WEBP"].contains(typeString)) {
      return CompressFormat.webp;
    }
    if ([".heic", ".heif", ".HEIC", ".HEIF"].contains(typeString)) {
      return CompressFormat.heic;
    }
    return CompressFormat.jpeg;
  }

  ///压缩 Uint8List、返回另外一个 Uint8List
  static Future<Uint8List> compressList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 720,
      minWidth: 480,
      quality: 40,
      rotate: 0,
    );
    return result;
  }

  ///压缩 asset、返回 Uint8List
  static Future<Uint8List?> compressAsset(String assetName) async {
    var list = await FlutterImageCompress.compressAssetImage(
      assetName,
      minHeight: 720,
      minWidth: 480,
      quality: 50,
      rotate: 0,
    );
    return list;
  }
}
