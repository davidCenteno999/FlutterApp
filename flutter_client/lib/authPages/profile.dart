import 'package:flutter/material.dart';
import 'package:flutter_client/navBar.dart';
import 'package:flutter_client/services/AuthServices.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final AuthService _authService = AuthService();

  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final rolCtrl = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
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
  

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: Navbar(),
          body: Center(
            child: Row(
              children: [
              SizedBox( 
              width: 350,
              height: 200,
              child: Card(
              color: Colors.white,
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
            ),
          
          SizedBox(
            width: 350,
            height: 200,
            child : Card(
              color: Colors.white,
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
                      Navigator.pushNamed(context, '/changePassword');
                    },
                    child: const Text("Change Password"),
                  ),
                ],
              ),
            ),
          ),
        )        
          ])));
      }
    
}
 