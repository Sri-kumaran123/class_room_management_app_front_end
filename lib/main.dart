import 'package:flutter/material.dart';
import 'package:my_conference_app/pages/onboarding_page.dart';
import 'package:my_conference_app/pages/plasscreen_page.dart';
import 'package:my_conference_app/providers/user_provider.dart';
import 'package:my_conference_app/services/auth_service.dart';
import 'package:provider/provider.dart';
//import 'package:my_conference_app/pages/assignment_page.dart';
//import 'package:my_conference_app/pages/chat_screen.dart';
import 'package:my_conference_app/pages/createclass_page.dart';
import 'package:my_conference_app/pages/home_page.dart';
import 'package:my_conference_app/pages/joinclass_page.dart';
import 'package:my_conference_app/pages/login_page.dart';
import 'package:my_conference_app/pages/profile_page.dart';
import 'package:my_conference_app/pages/signup_page.dart';
// import 'package:my_conference_app/pages/teacherstudentlist_page.dart';
// import 'package:my_conference_app/pages/create_assignment_page.dart';
// import 'package:my_conference_app/pages/uploadmeterial_page.dart';
// import 'package:my_conference_app/pages/assignmentsubmit_page.dart';
// import 'package:my_conference_app/pages/classsttings_page.dart';


void main() {
  runApp(MultiProvider( 
    providers:[
      ChangeNotifierProvider(create: (_) => UserProvider())
    ],
    //child:MyApp()
    child: MyApp(),
    )
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSplashScreen();
    authService.getUserData(context);
  }

  Future<void> _loadSplashScreen() async {
    // Simulate a delay for the splash screen
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        home: SplashScreen(), // Your custom SplashScreen widget
      );
    }

    return MaterialApp(
      title: 'Flutter Classroom App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Provider.of<UserProvider>(context).user.token.isEmpty
          ? LoginPage()
          : ClassroomHomePage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => ClassroomHomePage(),
        '/profile': (context) => ProfilePage(),
        '/joinclass': (context) => JoinClassPage(),
        '/createclass': (context) => CreateClassPage(),
        '/onboard':(context) => OnboardingScreen(),
      },
    );
  }
}