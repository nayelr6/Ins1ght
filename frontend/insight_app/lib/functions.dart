import 'package:image_picker/image_picker.dart';

Future getImage(ImageSource source) async {
  final _picker = ImagePicker();

  final _pickedFile = await _picker.pickImage(source: source);
  if(_pickedFile != null) {
    return _pickedFile.path;
  }

}