import 'package:flutter/material.dart';
import 'package:flutter_client/navBar.dart';
import 'package:flutter_client/services/taskServices.dart';

class UpdateTaskPage extends StatefulWidget {
  const UpdateTaskPage({super.key});

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}


class _UpdateTaskPageState extends State<UpdateTaskPage> {

  final Taskservices _taskService = Taskservices();
 
  final taskIdCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final imageUrl = TextEditingController();
  final userName = TextEditingController();
  final List<String> taskTypes = [];


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Navbar(),
      body: Center(
        
      ),
    );
  }
}