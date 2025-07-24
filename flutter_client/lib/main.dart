import 'package:flutter/material.dart';
import 'package:flutter_client/SplashScreen.dart';
import 'package:flutter_client/authPages/loginPage.dart';
import 'package:flutter_client/authPages/profile.dart';
import 'package:flutter_client/authPages/registerPage.dart';
import 'package:flutter_client/navBar.dart';
import 'package:flutter_client/services/AuthGuard.dart';
import 'package:flutter_client/taskPages/createTask.dart';
import 'package:flutter_client/taskPages/taskHome.dart';
import 'package:flutter_client/taskPages/updateTask.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Import the Register page


void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 84, 52, 124),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,

      home:  const Profile(), // Use Navbar as the home widget

      routes: {
        '/home': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/login': (context) => const Loginpage(),
        '/register': (context) => const Registerpage(),
        '/profile': (context) => const Profile(),
        '/taskHome': (context) => const Taskhome(),
        '/createTask': (context) => const Createtask(),
        

      }, // Added routes for login and register

      onGenerateRoute: (settings) {
        if (settings.name == '/updateTask') {
          final taskId = settings.arguments as String;
          if (taskId != null && taskId.isNotEmpty) {
            return MaterialPageRoute(
              builder: (context) => UpdateTaskPage(taskId: taskId),
            );
          } else {
            return MaterialPageRoute(
              builder: (context) => const Text('Error: Task ID not provided'),
            );
          }
        }
        return null; // Return null for unhandled routes
      },

      // Removed 'const' from routes to match constructors
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: Navbar(),
      
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Hello:',
            style: TextStyle(color: Colors.deepOrange)),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
