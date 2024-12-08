import 'package:flutter/material.dart';
import 'package:my_conference_app/services/workingwithclass_service.dart';

class CreateClassPage extends StatefulWidget {
  @override
  _CreateClassPageState createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClassPage> {
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _classDescriptionController =TextEditingController();
  final CreateClasses createclassdata = CreateClasses();
  String? _errorMessage;

  void _createClass() {
    final className = _classNameController.text.trim();
    final classDescription = _classDescriptionController.text.trim();
    if (className.isEmpty) {
      setState(() {
        _errorMessage = "Class name cannot be empty.";
      });
    } else {
      setState(() {
        _errorMessage = null;
      });
      createclassdata.createClassRoom(
        context: context, 
        name: className, 
        description: classDescription
      );
      
      // Add class creation logic or navigate to class list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Class"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.class_,
                size: 100,
                color: Colors.blueAccent,
              ),
              SizedBox(height: 20),
              Text(
                "Create a New Class",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Fill in the details below to create your class.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              TextField(
                controller: _classNameController,
                decoration: InputDecoration(
                  labelText: "Class Name",
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.edit, color: Colors.blueAccent),
                  errorText: _errorMessage,
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _classDescriptionController,
                decoration: InputDecoration(
                  labelText: "Class Description",
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.description, color: Colors.blueAccent),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _createClass,
                child: Text("Create Class"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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