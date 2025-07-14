import 'package:flutter/material.dart';


class Navbar extends StatefulWidget implements PreferredSizeWidget {
  
  
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NavbarState extends State<Navbar> {
  

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
              Navigator.pushNamed(context, '/login');
            },
          ),
          IconButton(onPressed: () {
            // Handle logout action
            Navigator.pushNamed(context, '/register');
          }, icon: const Icon(Icons.add))
        ],
      ),

      
    );
  }
}

