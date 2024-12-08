import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_conference_app/model/classes.dart';
import 'package:http/http.dart' as http;
import 'package:my_conference_app/pages/codedisplay_page.dart';
import 'package:my_conference_app/providers/user_provider.dart';
import 'package:my_conference_app/utils/constants.dart';
import 'package:my_conference_app/utils/util.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class CreateClasses {
  static String generateRandomString() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();

    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void createClassRoom({
    required BuildContext context,
    required String name,
    required String description,
  }) async {
    try {
      final String adminCode = generateRandomString();
      final String memberCode = generateRandomString();

      // Creating a classroom object
      Classes classroom = Classes(
        id: '', // Server will generate ID
        name: name,
        description: description,
        admincode: adminCode,
        membercode: memberCode,
        admin: [],
        members: [],
        assignments: [],
        material: []
      );
      print(classroom.toJson());
      // Making an HTTP POST request
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/class'),
        body: classroom.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Handling HTTP response
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // Navigating to the CodeDisplayPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CodeDisplayPage(
                adminCode: adminCode,
                memberCode: memberCode,
                className: name,
              ),
            ),
          );
        },
      );
    } catch (e) {
      // Displaying an error message
      showSnackBar(context, 'Error: ${e.toString()}');
    }
  }

  void joinClassroom({
    required BuildContext context,
    required userId,
    required code,
  }) async {
    try{
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/uclass'),
        body: json.encode({
          'userId':userId,
          'code':code
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: () {
          showSnackBar(
            context, 
            'Account Created'
          );
        }
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> retiveclass({
    required BuildContext context
  }) async {
    try{
      final user = Provider.of<UserProvider>(context).user;
      final List<dynamic> classIds = user.classes; // Assuming `classes` is a List<String>

    // Store the retrieved class data
    List<Map<String, dynamic>> classData = [];
    for (String id in classIds) {
      // Make an HTTP GET request for each class ID
      final response = await http.get(Uri.parse('${Constants.uri}/class/$id'));

      if (response.statusCode == 200) {
        // Parse the response body and add it to the class data list
        classData.add(json.decode(response.body));
      } else {
        // Handle error for this specific request
        debugPrint('Failed to load data for class ID: $id');
      }
    }
    print(classData);

    return classData.toList();

    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }

}
