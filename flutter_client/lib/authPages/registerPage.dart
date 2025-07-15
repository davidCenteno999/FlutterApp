import 'package:flutter_client/services/AuthServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/navBar.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final AuthService _authService = AuthService();

   void register() async {
    if (passwordCtrl.text != confirmPasswordCtrl.text) {
       print("Passwords do not match");
    } else {
      var response = await _authService.register(
        usernameCtrl.text,
        emailCtrl.text,
        passwordCtrl.text,
      );
      if (response.statusCode == 200) {
        print("Registration successful");
        print(response.body);
      } else {
        print("Registration failed");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      body: Center(
        child: Container(
          alignment: AlignmentDirectional.topCenter,
          width: 350,
          height: 450,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.5),
            color: const Color.fromARGB(255, 149, 169, 235),
          ),
          child: Column(
            children: [
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 214, 230, 226),
                ),
              ),
              const SizedBox(height: 30), // Add margin bottom
              TextField(
                controller: usernameCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                
                controller: emailCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                controller: passwordCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                controller: confirmPasswordCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                ),
              ),
             
             const SizedBox(height: 40),
              SizedBox(
                width: 150, // Adjust the width as needed
                height: 40, // Adjust the height as needed
                child: ElevatedButton(
                  onPressed: () {
                    register();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 214, 230, 226),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Register'),
                  
                ),
              ),
            ]
          ),

        )
      )
    );
  }
}