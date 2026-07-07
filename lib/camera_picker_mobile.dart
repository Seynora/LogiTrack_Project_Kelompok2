import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickCameraImageImpl() async {
  final ImagePicker picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);
  return pickedFile == null ? null : await pickedFile.readAsBytes();
}
