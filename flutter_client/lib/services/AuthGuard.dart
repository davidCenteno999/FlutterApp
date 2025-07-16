import 'package:flutter/material.dart';
import 'package:flutter_client/services/AuthServices.dart';
import 'package:flutter_client/authPages/loginPage.dart';

//StatlessWidget: use when the widget does not require mutable state
//StatfullWidget: use when the widget requires mutable state
// AuthGuard is a widget that checks if the user is logged in before allowing access to certain pages
// If the user is not logged in, it redirects them to the login page

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return child; 
        } else {
         
          return const Loginpage(); 
        }
      },
    );
  }
}
