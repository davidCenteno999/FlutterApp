import 'package:flutter/material.dart';
import 'package:flutter_client/models/dtos/LoginDto.dart';
import 'package:flutter_client/navBar.dart';
import 'package:flutter_client/services/AuthServices.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});



  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {

  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> _handleLogin() async {

    final LoginDto loginDto = LoginDto(
      email: usernameCtrl.text,
      password: passwordCtrl.text,
    );

    var response = await _authService.login(loginDto);
    if (!mounted) return; 
    if (response == true) {
      Navigator.pushNamed(context, '/home');
    } else {
      print("Login failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      body: Center(
        child: Container(
          alignment: AlignmentDirectional.topCenter,
          width: 350,
          height: 400,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.5),
            color: const Color.fromARGB(255, 149, 169, 235),
          ),
          child: Column(
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 214, 230, 226),
                ),
              ),
              const SizedBox(height: 30), // Add margin bottom
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                controller: usernameCtrl,
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                controller: passwordCtrl,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 150, // Adjust the width as needed
                height: 40, // Adjust the height as needed
                child: ElevatedButton(
                  onPressed: () {
                    _handleLogin();
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 214, 230, 226),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  'Don\'t have an account? Sign up',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 224, 228, 231),
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



