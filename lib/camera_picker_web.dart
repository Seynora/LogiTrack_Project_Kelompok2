import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickCameraImageImpl() async {
  if (!kIsWeb) {
    return null;
  }

  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
  return pickedFile == null ? null : await pickedFile.readAsBytes();
}
