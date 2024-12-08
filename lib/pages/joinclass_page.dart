import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:my_conference_app/providers/user_provider.dart';
import 'package:my_conference_app/services/workingwithclass_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Join Class',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JoinClassPage(),
    );
  }
}

class JoinClassPage extends StatefulWidget {
  @override
  _JoinClassPageState createState() => _JoinClassPageState();
}

class _JoinClassPageState extends State<JoinClassPage> {
  final CreateClasses joinclass = CreateClasses();
  
  TextEditingController _classCodeController = TextEditingController();
  String? _errorMessage;

  void _joinClass(String Id) {
    final code = _classCodeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _errorMessage = "Class code cannot be empty.";
      });
    } else {
      setState(() {
        _errorMessage = null;
      });
     joinclass.joinClassroom(context: context, userId: Id, code: code);
      // Proceed to join the class or navigate to the class page
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context,listen: false).user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Class"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.school,
                size: 100,
                color: Colors.blueAccent,
              ),
              SizedBox(height: 20),
              Text(
                "Enter the class code",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Ask your teacher for the class code to join.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              TextField(
                controller: _classCodeController,
                decoration: InputDecoration(
                  labelText: "Class Code",
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.code, color: Colors.blueAccent),
                  errorText: _errorMessage,
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: (){
                  _joinClass(user.id);
                },
                child: Text("Join Class"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}