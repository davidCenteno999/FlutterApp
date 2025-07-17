import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_client/models/taskTypeDto/getTaskTypeDto.dart';
import 'package:flutter_client/navBar.dart';
import 'package:flutter_client/services/taskServices.dart';
import 'package:flutter_client/services/uploadImages.dart';

class Createtask extends StatefulWidget {
  const Createtask({super.key});

  @override
  State<Createtask> createState() => _CreatetaskState();
}


class _CreatetaskState extends State<Createtask> {

  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final imageIdCtrl = TextEditingController();
  final imageUrlCtrl = TextEditingController();
  final taskTypeCtrl = TextEditingController();
  final List<String> taskTypes = [];
  late final Size size = MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      body: Center(
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.9,
          child: Card(
            elevation: 9,
            color: const Color.fromARGB(255, 152, 105, 240),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Create Task',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 209, 219, 219),
                  )),
                  const SizedBox(height: 20),
                  TitleInput(controller: titleCtrl),
                  const SizedBox(height: 10),
                  DescriptionInput(controller: descriptionCtrl),
                  const SizedBox(height: 10),
                  ImageInput(controllerUrl: imageUrlCtrl, controllerId: imageIdCtrl),
                  const SizedBox(height: 10),
                  const Text(
                    'Image Preview:',
                    style: TextStyle(
                      fontSize: 9,
                      
                    )
                    ),
                  if (imageUrlCtrl.text.isNotEmpty) 
                    Image.network(
                      imageUrlCtrl.text,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 10),
                  TaskTypeInput(controller: taskTypes),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
                  
 
class TitleInput
 extends StatelessWidget {

  final TextEditingController controller;

  const TitleInput
  ({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return  Row(
        spacing: 10,
        children: [
          Icon(
            Icons.badge,
            color: Color.fromARGB(255, 209, 219, 219),

          ),
          Expanded(
            child: TextField(
            style: TextStyle(
              color: Color.fromARGB(255, 209, 219, 219),
            ),
            cursorColor: Color.fromARGB(255, 209, 219, 219),
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Title',
              
              border: OutlineInputBorder(),
            ),
            ),
          ),
        ],
      );
  }
}

class DescriptionInput extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Icon(
          Icons.description,
          color: Color.fromARGB(255, 209, 219, 219),
        ),
        Expanded(
          child: TextField(
            style: TextStyle(
              color: Color.fromARGB(255, 209, 219, 219),
            ),
            cursorColor: Color.fromARGB(255, 209, 219, 219),
            controller: controller,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

class ImageInput extends StatefulWidget {
  final TextEditingController controllerUrl;
  final TextEditingController controllerId;

  const ImageInput({super.key, required this.controllerUrl, required this.controllerId});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? imageFile;
  final UploadImage _uploadImage = UploadImage();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.image,
          color: const Color.fromARGB(255, 209, 219, 219),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            imageFile == null ? "No image selected" : "Image selected", // Para evitar overflow
            style: const TextStyle(
              fontSize: 5,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
        width: 100,
        child: ElevatedButton(
          
          onPressed: () async {
            final result = await _uploadImage.selectImage();
            if (result != null) {
              setState(() {
                imageFile = result;
              });
            }
          },
          child: const Text("Select Image",
          style: TextStyle(
            fontSize: 9
          ),
          textAlign: TextAlign.center,
          ),
        )),
        const SizedBox(width: 10),
        SizedBox(
        width: 100,
        child: ElevatedButton(
          onPressed: () async {
            if (imageFile == null) return;
            final result = await _uploadImage.uploadImage(imageFile!);
            print("Image upload result: $result");
            if (result != null) {
              setState(() {
                widget.controllerUrl.text = result.url;
                widget.controllerId.text = result.id;
              });
            } else {
              print("Image upload failed");
            }
          },
          child: const Text("Upload Image",
          style: TextStyle(
            fontSize: 9
          ),
          textAlign: TextAlign.center,
          ),
        ))
      ],
    );

  }
}

class  TaskTypeInput extends StatefulWidget {
  final List<String> controller;
  const  TaskTypeInput({super.key, required this.controller});

  @override
  State< TaskTypeInput> createState() => _TaskTypeInputState();
}



class _TaskTypeInputState extends State< TaskTypeInput> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Taskservices().fetchTaskTypes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final taskTypes = snapshot.data?.list_names ?? [];
          print("Task types: $taskTypes");
          return ListView.builder(
            itemCount: taskTypes.length,
            itemBuilder: (context, index) {
              final taskType = taskTypes[index];
              return ListTile(
                title: Text(taskType),
                onTap: () {
                  widget.controller.add(taskType);
                },
              );
            },
          );
        }
      },
    );
  }
}