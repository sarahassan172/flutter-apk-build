import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class ImageController extends GetxController{
  final Rx<XFile?> selectedImage =Rx<XFile?>(null);

  Future<void> pickImage() async{
    final ImagePicker picker =ImagePicker();
    try{
      final XFile? image =await picker.pickImage(source:ImageSource.gallery);
      if(image!=null){
        selectedImage.value=image;
      }
    }
    catch(e){
      print("Image pick error:$e");
    }
  }
}