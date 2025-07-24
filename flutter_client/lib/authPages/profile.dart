import 'package:flutter/material.dart';
import 'package:flutter_client/models/taskDto/getTaskDto.dart';
import 'package:flutter_client/navBar.dart';
import 'package:flutter_client/services/AuthServices.dart';
import 'package:flutter_client/services/taskServices.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final AuthService _authService = AuthService();
  final Taskservices _taskService = Taskservices();

  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final rolCtrl = TextEditingController();
  late final Size size = MediaQuery.of(context).size;

  final List<GetTask> tasksUser = [];
  
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadTasksUser();
  }

  void _loadUserProfile() async {
    var userProfile = await _authService.getCurrentUser();
    if (userProfile != null) {
      setState(() {
        usernameCtrl.text = userProfile.username;
        emailCtrl.text = userProfile.email;
        rolCtrl.text = userProfile.role;
      });
      print("User profile loaded successfully");
    } else {
      print("Failed to load user profile");
    }
  }

  void _loadTasksUser() async{
    var userId = await _authService.getUserId();
    print("User ID: $userId");
    if (userId != null) {
      var tasks = await _taskService.getTasksByUser(userId);
      
      if (tasks != null) {
        // Process tasks as needed
        setState(() {
          tasksUser.addAll(tasks);
        });
        print("Tasks loaded successfully");
      } else {
        print("Failed to load user tasks");
      }
    } else {
      print("User ID is null");
    }
  }
  

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: Navbar(),
          body: Center(

          child: Container(
            width: size.width * 0.8,
            height: size.height * 0.8,
            child: Column(
              children: [Row(

              children: [
              UserInfo(usernameCtrl: usernameCtrl, emailCtrl: emailCtrl, rolCtrl: rolCtrl),
              ActionButtons(),
          ]
          ),
          TaskListUser(tasks: tasksUser),
                ]
          ))));
      }
    
}
 


class UserInfo extends StatelessWidget {

  final TextEditingController usernameCtrl;
  final TextEditingController emailCtrl ;
  final TextEditingController rolCtrl;

  const UserInfo({super.key, required this.usernameCtrl, required this.emailCtrl, required this.rolCtrl});


  @override
  Widget build(BuildContext context) {
    return SizedBox( 
          width: 350,
          height: 200,
          child: Card(
          color: const Color.fromARGB(255, 183, 155, 235),
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.blue),
                    const SizedBox(width: 10),
                    Text(
                      usernameCtrl.text,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.email, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(
                      emailCtrl.text,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.security, color: Colors.orange),
                    const SizedBox(width: 10),
                    Text(
                      'Rol: ${rolCtrl.text}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }
}


class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            width: 350,
            height: 200,
            child : Card(
              color: const Color.fromARGB(255, 183, 155, 235),
              elevation: 5,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                  const Text(
                    "Action Buttons",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle edit profile action
                      Navigator.pushNamed(context, '/editProfile');
                    },
                    child: const Text("Edit Profile"),
                  ),
                  
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle change password action
                      Navigator.pushNamed(context, '/createTask');
                    },
                    child: const Text("Create Task"),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

class TaskListUser extends StatefulWidget {

  final List<GetTask> tasks;
  const TaskListUser({super.key, required this.tasks});

  @override
  State<TaskListUser> createState() => _TaskListUserState();
}

class _TaskListUserState extends State<TaskListUser> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 550,
      height: 200,
      child: Card(
        color: const Color.fromARGB(255, 183, 155, 235),
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "User Tasks",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: scrollController,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: widget.tasks.length,
                    itemBuilder: (context, index) {
                      final task = widget.tasks[index];
                      return Card(
                        
                        child:ListTile(
                        leading: Image.network(task.imageUrl,
                        height: 30,
                        width: 30, 
                        ),
                        title: Text(task.title),
                        style: ListTileStyle.drawer,
                        onTap: () {
                          // Handle task tap
                          Navigator.pushNamed(context, '/updateTask', arguments: task.id);
                        },
                      ));
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}