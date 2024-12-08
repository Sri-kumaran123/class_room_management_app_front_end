

import 'dart:convert';
import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
//import 'dart:html' as html; 


import 'package:flutter/material.dart';
import 'package:my_conference_app/providers/user_provider.dart';
import 'package:my_conference_app/utils/constants.dart';
import 'package:my_conference_app/utils/util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MaterialService{
  Future<List<Map<String,dynamic>>> retriveMaterial({
    required BuildContext context,
    required String classid,
    required List<dynamic> materials,
  }) async {
    try{
      List <Map<String, dynamic>> materialsdata =[];
      for (String id in materials) {
      
      final response = await http.get(Uri.parse('${Constants.uri}/meterial/detail/$id'));

      if (response.statusCode == 200) {
        
        materialsdata.add(json.decode(response.body));
      } else {
        
        debugPrint('Failed to load data for assignment ID: $id');
      }
    }

      return materialsdata.toList();

    } catch (e){
      showSnackBar(context, e.toString());
      return [];
    }
  }

 Future<void> uploadFile({
  required selectedFile,
  required classid,
  required String filename,
  String type = '0'
 }) async {
    try{
      if (selectedFile == null) return;

    final request = http.MultipartRequest(
      "POST",
      Uri.parse('${Constants.uri}/meterial/'), // Replace with your API URL
    );

    if(type == '0'){
      request.files.add(await http.MultipartFile.fromBytes(
      'file', // Parameter name expected by API
      selectedFile,
      filename: filename,
    ));
    } else {
      request.files.add(await http.MultipartFile.fromPath(
      'file', // Parameter name expected by API
      selectedFile,
      filename: filename,
    ));
    }

    request.files.add(await http.MultipartFile.fromBytes(
      'file', // Parameter name expected by API
      selectedFile,
      filename: filename,
    ));
    request.fields['classid'] = classid;
    request.fields['name']=filename;
    final response = await request.send();

    if (response.statusCode == 200) {
      print("File uploaded successfully");
    } else {
      print("File upload failed");
    }

    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> downloadFile(String filename,String id) async {
  
  // ignore: unnecessary_brace_in_string_interps
  final response = await http.get(Uri.parse('${Constants.uri}/meterial/${id}'));

  try{
    if (response.statusCode == 200) {
    if (kIsWeb) {
      // For Web: Trigger a download
      /* final blob = html.Blob([response.bodyBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = filename
        ..click();
      html.Url.revokeObjectUrl(url);  */// Clean up the URL
      print('File download triggered for web.');
    } else if (Platform.isAndroid || Platform.isIOS) {
      // For mobile (Android/iOS): Save the file locally
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$filename';

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      print('File downloaded at: $filePath');
    }
  } else {
    print('Failed to download file: ${response.statusCode}');
    print(response.body);
  }

  } catch (e) {
    print(e.toString());
  }
}



//---
Future<void> uploadSubmitFile({
  required BuildContext context,
  required selectedFile,
  required String filename,
  required String assid,
  required String userid,
  String type = '0'
 }) async {
    try{
      
      if (selectedFile == null) return;

    final request = http.MultipartRequest(
      "POST",
      Uri.parse('${Constants.uri}/meterial/submit'), // Replace with your API URL
    );
    if(type == '0'){
      request.files.add(await http.MultipartFile.fromBytes(
      'file', // Parameter name expected by API
      selectedFile,
      filename: filename,
    ));
    } else {
      request.files.add(await http.MultipartFile.fromPath(
      'file', // Parameter name expected by API
      selectedFile,
      filename: filename,
      ));
    }
    
    request.fields['userid'] = userid;
    request.fields['name']=filename;
    final response = await request.send();

    if (response.statusCode == 200) {
      print("File uploaded successfully");
    } else {
      print("File upload failed");
    }

    } catch (e) {
      print(e.toString());
    }
  }

}