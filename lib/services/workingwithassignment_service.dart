
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_conference_app/model/assignments.dart';
import 'package:my_conference_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:my_conference_app/utils/util.dart';
class AssignmentService{
  Future<List<Map<String, dynamic>>> retiveAssignments({
    required BuildContext context,
    required String classid,
    required List<dynamic> assignments,
  }) async {
    try{
      
    List<Map<String, dynamic>> assignmentdata = [];
    for (String id in assignments) {
      
      final response = await http.get(Uri.parse('${Constants.uri}/assignment/$id'));

      if (response.statusCode == 200) {
        
        assignmentdata.add(json.decode(response.body));
      } else {
        
        debugPrint('Failed to load data for assignment ID: $id');
      }
    }
    print(assignmentdata);

    return assignmentdata.toList();

    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }

  void addAssignment({
    required BuildContext context,
    required String title,
    required String description,
    required DateTime lastDate,
    required String classid
  }) async {
    try{
      TaskAss assign = TaskAss(
        title: title, 
        description: description, 
        submition: [], 
        lastDate: lastDate, 
        classid: classid);

        // ignore: unused_local_variable
        http.Response res = await http.post(
        Uri.parse('${Constants.uri}/assignment/'),
        body:  jsonEncode(assign.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        
      );

    } catch (e) {
      showSnackBar(context, 'Error: ${e.toString()}');
    }
  }
}