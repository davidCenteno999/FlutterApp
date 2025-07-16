import 'package:flutter/material.dart';
import 'package:flutter_client/services/AuthServices.dart';


class Navbar extends StatefulWidget implements PreferredSizeWidget {
  
  
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NavbarState extends State<Navbar> {
  
  final AuthService _authService = AuthService();

  void _logout() async {
    
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text("Task Manager"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings action
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(onPressed: () {
            // Handle logout action
            Navigator.pushNamed(context, '/register');
          }, icon: const Icon(Icons.add)),
          
          FutureBuilder(future: _authService.isLoggedIn(), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 14,
                height: 14,
                
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.data == true) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _logout();
                },
              );
            } else {
              return Container(); // No logout button if not logged in
            }
          }),
          
        ],
      ),

      
    );
  }
}

