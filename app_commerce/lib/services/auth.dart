import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

   String local = 'http://192.168.250.5:4000';

  // Register
  Future registerNewUser(Map user) async {
    
    //URL API
    String url = '$local/auth/signup';

    //API response
    var response = await http.post(url, body: user);

    //JSON to Map
    var data = jsonDecode(response.body);

    //Verify Error
    if (data['err'] == null) {
      return null;
    }
    return data['err'];
  }

  // Sign in with email & password
  Future signIn(String email, String password) async {
    //Data User
    Map user = {'email': email, 'password': password};

    //API URL
    String url = "$local/auth/signin";

    //API response
    var response = await http.post(url, body: user);

    //JSON to Map
    var data = jsonDecode(response.body);

    if (data["err"] == null) {

      //Get instance SharedPrederences
      SharedPreferences sharedPreferences;
      sharedPreferences = await SharedPreferences.getInstance();

      //Save credentials with SharedPreferences
      sharedPreferences.setString("token", data["token"]);
      sharedPreferences.setString("commerce_id", data["user_id"]);
      sharedPreferences.setString("commerce_name", data["user_name"]);
      sharedPreferences.setString("commerce_email", data["user_email"]);

      //Return dont error
      return null;
    }

    //Return error
    return data['err'];
  }

  // Password reset
  Future resetPassword(String email) async {}

  // Sign out
  Future signOut() async {
    //Get token auth
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}
