import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final imagePicker = ImagePicker();
  var file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  print('No images selected');
}
