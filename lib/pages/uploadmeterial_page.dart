

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:my_conference_app/services/workingwithmatterial_service.dart'; // For kIsWeb

class UploadFilePage extends StatefulWidget {
  final String classid;

  UploadFilePage({
    required this.classid,
  });
  @override
  _UploadFilePageState createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  final TextEditingController _titleController = TextEditingController();
  final MaterialService matservice = MaterialService();
  PlatformFile? _pickedFile; // File metadata for both Web and Mobile
  Uint8List? _fileBytes; // To handle file bytes for Web

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
        _fileBytes = result.files.first.bytes; // Web: Store file bytes
      });
    }
  }

  void _submitFile() {
    final String title = _titleController.text;

    if (title.isEmpty || _pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in the title and upload a file.')),
      );
      return;
    }

    // Handle file data
    if (kIsWeb) {
      // On Web, use the file bytes for processing
      print('Title: $title');
      print('File Name: ${_pickedFile!.name}');
      print('File Size: ${_pickedFile!.size} bytes');
      print('File Bytes: ${_fileBytes!.length}');
      matservice.uploadFile(selectedFile: _pickedFile!.bytes, classid: widget.classid,filename: _pickedFile!.name);
     // Demonstrating file size
    } else {
      // On Mobile, use the file path
      print('Title: $title');
      print('File Name: ${_pickedFile!.name}');
      print('File Path: ${_pickedFile!.path}');
      matservice.uploadFile(selectedFile: _pickedFile!.path, classid: widget.classid,filename: _pickedFile!.name,type: '1');
    }

   

    

    // Reset fields
    _titleController.clear();
    setState(() {
      _pickedFile = null;
      _fileBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload File'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('File Title'),
              _buildTextField(
                controller: _titleController,
                hint: 'Enter file title',
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Upload File'),
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue[50],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_upload, size: 40, color: Colors.blueAccent),
                        SizedBox(height: 8),
                        Text(
                          _pickedFile == null
                              ? 'Tap to upload file'
                              : 'File Selected: ${_pickedFile!.name}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitFile,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Submit'),
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
  }) {
    return TextField(
      controller: controller,
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


