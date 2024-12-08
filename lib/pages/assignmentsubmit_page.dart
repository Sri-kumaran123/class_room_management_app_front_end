import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:my_conference_app/providers/user_provider.dart';
import 'package:my_conference_app/services/workingwithmatterial_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SubmitAssignmentPage extends StatefulWidget {
  final String assid;

  SubmitAssignmentPage({
    required this.assid
  });
  @override
  _SubmitAssignmentPageState createState() => _SubmitAssignmentPageState();
}

class _SubmitAssignmentPageState extends State<SubmitAssignmentPage> {
  final MaterialService asssubservice = MaterialService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  PlatformFile? _pickedFile;
  Uint8List? _fileBytes;

  Future<void> _checkPermissionAndPickFile() async {
    if (kIsWeb) {
      _pickFile();
    } else {
      if (await Permission.storage.isGranted) {
        _pickFile();
      } else {
        PermissionStatus status = await Permission.storage.request();
        if (status.isGranted) {
          _pickFile();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Storage permission is required to upload a file.')),
          );
        }
      }
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
        _fileBytes = result.files.first.bytes;
      });
    }
  }

  void _submitAssignment() {
    final String title = _titleController.text;
    final String description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty || _pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields and upload a file.')),
      );
      return;
    }
    final user = Provider.of<UserProvider>(context,listen: false).user;
    // Handle assignment submission
    if (kIsWeb) {
      print('Title: $title');
      print('Description: $description');
      print('File Name: ${_pickedFile!.name}');
      print('File Size: ${_pickedFile!.size} bytes');
      asssubservice.uploadSubmitFile(context: context, selectedFile: _pickedFile!.bytes, filename: _pickedFile!.name, assid: widget.assid,userid: user.id);
    } else {
      print('Title: $title');
      print('Description: $description');
      print('File Path: ${_pickedFile!.path}');
      asssubservice.uploadSubmitFile(context: context, selectedFile: _pickedFile!.path, filename: _pickedFile!.name, assid: widget.assid,type: '1',userid: user.id);
    }

   

    // Clear the fields
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _pickedFile = null;
      _fileBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Assignment'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Assignment Title'),
              _buildTextField(
                controller: _titleController,
                hint: 'Enter assignment title',
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Description'),
              _buildTextField(
                controller: _descriptionController,
                hint: 'Enter assignment description',
                maxLines: 4,
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Upload File'),
              GestureDetector(
          onTap: _checkPermissionAndPickFile,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue, width: 2), // Blue border
              borderRadius: BorderRadius.circular(16), // More rounded corners
              color: Colors.blue[50], // Light blue background
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.3),
                  offset: Offset(0, 4),
                  blurRadius: 6,
                ),
              ], // Shadow for a more 3D look
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.file_upload, size: 40, color: Colors.blueAccent), // Blue upload icon
                  SizedBox(height: 10),
                  Text(
                    _pickedFile == null
                        ? 'Tap to upload file'
                        : 'File Selected: ${_pickedFile!.name}', // Show file name
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue, // Blue text color
                      fontSize: 16,
                      fontWeight: FontWeight.bold, // Bold font for emphasis
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitAssignment,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Submit Assignment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String hint = '',
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}


