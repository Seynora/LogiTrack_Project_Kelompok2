import 'dart:typed_data';
import 'camera_picker_mobile.dart'
    if (dart.library.html) 'camera_picker_web.dart';

Future<Uint8List?> pickCameraImage() => pickCameraImageImpl();
