import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:gb/common/third_party/image_compress.dart';
import 'package:path/path.dart' as new_path;

class FirebaseStorageManage {
  FirebaseStorageManage._();
  static FirebaseStorage storage = FirebaseStorage.instance;

  // static FirebaseStorageManage? _instance;

  ///上传图片
  static Future<String?> uploadImage(File file, String path) async {
    var fileName = '$path${new_path.extension(file.path)}';
    final storageRef = storage.ref().child(fileName);
    String? imageUrl;
    try {
      File newFile = (await compressImage(file)) ?? file;
      await storageRef.putFile(newFile);
      imageUrl = await storageRef.getDownloadURL();
     } catch (_) {}
    return imageUrl;
  }

  ///将图片file上传到path，用name命名文件夹，用number命名图片名
  static Future<String?> uploadDocument(
      File file, String path, String name, int number) async {
    var fileName = '$path$name/$number${new_path.extension(file.path)}';
    final storageRef = storage.ref().child(fileName);
    String? imageUrl;
    try {
      File newFile = (await compressImage(file)) ?? file;
      await storageRef.putFile(newFile);
      imageUrl = await storageRef.getDownloadURL();
    } catch (_) {}
    return imageUrl;
  }

  ///压缩图片
  static Future<File?> compressImage(File filePath) async {
    dynamic compressedSourceFile;
    try {
      compressedSourceFile = await FImageCompress.compressFileAndGetFile(
        filePath,
        '${new_path.withoutExtension(filePath.path)}_compressed${new_path.extension(filePath.path)}',
        type: new_path.extension(filePath.path),
      );
    } catch (_) {}
    return compressedSourceFile?.path == null
        ? null
        : File(compressedSourceFile!.path);
  }

  static void getInstance() {}
}
