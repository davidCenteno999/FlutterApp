import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_client/models/taskDto/createTaskDto.dart';
import 'package:flutter_client/models/taskTypeDto/getTaskTypeDto.dart';
import 'package:flutter_client/navBar.dart';
import 'package:flutter_client/services/AuthServices.dart';
import 'package:flutter_client/services/taskServices.dart';
import 'package:flutter_client/services/uploadImages.dart';
import 'package:image_picker/image_picker.dart';

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

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descriptionCtrl.dispose();
    imageIdCtrl.dispose();
    imageUrlCtrl.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      body: Center(
        child: Container(
          width: size.width * 0.7,
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
                  const SizedBox(height: 20),
                  ImageInput(controllerUrl: imageUrlCtrl, controllerId: imageIdCtrl),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child:  Text(
                    'Select Task Types',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 209, 219, 219),
                    ),
                  ),),
                  TaskTypeInput(controller: taskTypes),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      
                     final userId = await _authService.getUserId();
                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User not logged in')),
                        );
                        return;
                      }
                      final task = Createtaskdto(
                        title: titleCtrl.text,
                        description: descriptionCtrl.text,
                        imageId: imageIdCtrl.text,
                        imageUrl: imageUrlCtrl.text,
                        userId: userId.toString(),
                        taskType: taskTypes,
                      );
                      
                      print(task.toJson());
                      final success = await Taskservices().createTask(task);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Task created successfully')),
                        );
                        dispose(); // Clear the form after successful creation
                        Navigator.pushNamed(context, '/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to create task')),
                        );
                      }
                    },
                    child: Text('Create Task'),
                  ),
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
  XFile? imageFile;
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
         Flexible(
          fit: FlexFit.loose,
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
            final result = await _uploadImage.selectImageWeb();
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
            final result = await _uploadImage.uploadImageWeb(imageFile!);
            setState(() {
              widget.controllerUrl.text = result.url;
              widget.controllerId.text = result.id;
            });
          
          },
          child: const Text("Upload Image",
          style: TextStyle(
            fontSize: 9
          ),
          textAlign: TextAlign.center,
          ),
        )),
        const SizedBox(width: 30),
        Expanded(child:Column(
          children: [
            if (widget.controllerUrl.text.isNotEmpty) 
            const Text(
              'Image Preview:',
              style: TextStyle(
                fontSize: 9,
                
              )
              ),
            SizedBox(height: 10),
            if (widget.controllerUrl.text.isNotEmpty) 
              Image.network(
                widget.controllerUrl.text,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 10),
          ],
        ) )
        
        
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

   late Future<Gettasktypedto> _taskTypesFuture;

   @override
   void initState() {
     super.initState();
     _taskTypesFuture = Taskservices().fetchTaskTypes();
   }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _taskTypesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final taskTypes = snapshot.data?.list_names ?? [];
          print("Task types: $taskTypes");
          return ListView.builder(
            shrinkWrap: true,
            itemCount: taskTypes.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CheckboxListTile(
                title: Text(taskTypes[index]),
                value: widget.controller.contains(taskTypes[index]),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      widget.controller.add(taskTypes[index]);
                      print(widget.controller);
                    } else {
                      widget.controller.remove(taskTypes[index]);
                    }
                  });
                },
              );
            },
        
          );
        }
      },
    );
  }
}




