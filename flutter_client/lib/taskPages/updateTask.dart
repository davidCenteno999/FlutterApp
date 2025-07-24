import 'package:flutter/material.dart';
import 'package:flutter_client/navBar.dart';
import 'package:flutter_client/services/taskServices.dart';

class UpdateTaskPage extends StatefulWidget {
  final String taskId;
  const UpdateTaskPage({super.key, required this.taskId});

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}


class _UpdateTaskPageState extends State<UpdateTaskPage> {

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  final Taskservices _taskService = Taskservices();
 
  final taskIdCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final imageUrl = TextEditingController();
  final userName = TextEditingController();
  late List<String> taskTypes = [];
  late final Size size = MediaQuery.of(context).size;


  void fetchData() async {
    try {
      var task = await _taskService.fetchTaskById(widget.taskId);
      if (task != null) {
        setState(() {
          taskIdCtrl.text = task.id;
          titleCtrl.text = task.title;
          descriptionCtrl.text = task.description;
          imageUrl.text = task.imageUrl;
          userName.text = task.userName;
          taskTypes = task.listTypeTask;
        });
      } else {
        print("Failed to fetch task data");
      }
    } catch (e) {
      print("Error fetching task data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      body: Center(
        child: Container(
          width: size.width * 0.5,
          height: size.height * 0.5,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: titleCtrl ,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: descriptionCtrl,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  TextField(
                    controller: imageUrl,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                    
                  ),
                  TextField(
                    controller: userName,
                    decoration: const InputDecoration(labelText: 'User Name'),
                  ),
                  // Add more fields as needed
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}