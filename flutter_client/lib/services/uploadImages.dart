import 'dart:convert';
import 'dart:io';

import 'package:flutter_client/models/imagesDto/imagesDto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadImage {

  static final UploadImage _instance = UploadImage._internal();
  factory UploadImage() {
    return _instance;
  }

   UploadImage._internal();

  var cloudName = dotenv.env['CLOUD_NAME'];
  var uploadPreset = dotenv.env['upload_preset'];

  Future<ImagesDto> uploadImage(File imageFile) async {
    print(cloudName);
    print(uploadPreset);
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    

    final response = await http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset ?? ''
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ));
    final streamedResponse = await response.send();
    final responseData = await http.Response.fromStream(streamedResponse);
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      ImagesDto imagesDto = ImagesDto.fromJson(data);
      print("Image uploaded successfully: ${imagesDto.url}");
      print("Image ID: ${imagesDto.id}");
      return imagesDto;
    } else {
      throw Exception('Failed to upload image: ${responseData.reasonPhrase}');
    }
  }

  Future<File?> selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }


  //====================================================
  // Web methods
  //====================================================
   Future<ImagesDto> uploadImageWeb(XFile imageFile) async {
    print(cloudName);
    print(uploadPreset);
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    

    final response = await http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset ?? '';
    
    final bytes = await imageFile.readAsBytes();

    response.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: imageFile.name,
    ));
  
    final streamedResponse = await response.send();
    final responseData = await http.Response.fromStream(streamedResponse);
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      ImagesDto imagesDto = ImagesDto.fromJson(data);
      print("Image uploaded successfully: ${imagesDto.url}");
      print("Image ID: ${imagesDto.id}");
      return imagesDto;
    } else {
      throw Exception('Failed to upload image: ${responseData.reasonPhrase}');
    }
  }
  
  Future<XFile?> selectImageWeb() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile;
    }
    return null;
  }

}