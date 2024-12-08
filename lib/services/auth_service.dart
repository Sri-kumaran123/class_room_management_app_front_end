import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:my_conference_app/model/user.dart';
import 'package:my_conference_app/pages/home_page.dart';
import 'package:my_conference_app/providers/user_provider.dart';
import 'package:my_conference_app/utils/constants.dart';
import 'package:my_conference_app/utils/util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  void signUpUser({
    required BuildContext context,
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      User user = User(
        id: '', 
        name: name, 
        email: email, 
        password: password, 
        token: ''
      );

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type':'application/json; charset=UTF-8',
        }
      );

      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: () {
          Navigator.pushReplacementNamed(context, '/login');
        }
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password
  }) async {
      try{
        var userProvider = Provider.of<UserProvider>(context,listen:false);
        final navigator = Navigator.of(context);
        http.Response res = await http.post(
          Uri.parse('${Constants.uri}/signin'),
          body: jsonEncode({
            'email':email,
            'password':password
          }),
          headers: <String, String>{
          'Content-Type':'application/json; charset=UTF-8',
         }
        );

        httpErrorHandle(
          response: res, 
          context: context, 
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            print(res.body);
            userProvider.setUser(res.body);
            await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
            navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ClassroomHomePage()
              ),
              (route)=> false
            );
          });
      } catch( e ) {
        showSnackBar(context, e.toString());
      }
  }

  void getUserData(
    BuildContext context,
  ) async {
    try{
      var userProvider = Provider.of<UserProvider>(context,listen:false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if(token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('${Constants.uri}/tokenisvalid'),
         headers: <String, String>{
          'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token!,
         }
      );

      var response = jsonDecode(tokenRes.body);

      if(response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${Constants.uri}/'),
          headers: <String, String>{
          'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token,
         }
        );

        userProvider.setUser(userRes.body); 
      }
    } catch (e) {

      showSnackBar(context, e.toString());
    }
  }
}