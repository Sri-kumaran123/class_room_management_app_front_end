

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_conference_app/utils/constants.dart';

class GetPeopleService {
  Future<List<Map<String,String>>> getNameList({
    required BuildContext context,
    required List<dynamic> peoplelist,
  }) async {
    try{
      List<Map<String,String>> people =[];
      for(String id in peoplelist){
        final response = await http.get(Uri.parse('${Constants.uri}/class/user/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        people.add({'name': data['name']});
      } else {
        
        debugPrint('Failed to load data for assignment ID: $id');
      }

      }
      
      print(people);
      return people;

    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}