import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

   String local = 'http://192.168.250.7:4000';

  // SignUp
  Future signUp(Map commerce) async {
    
    //URL API
    String url = '$local/auth/signupcommerce';

    //API response
    var response = await http.post(url, body: commerce);

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
    //Commerce credentials 
    Map credentials = {'email': email, 'password': password};

    //API URL
    String url = "$local/auth/signincommerce";

    //API response
    var response = await http.post(url, body: credentials);

    //JSON to Map
    var data = jsonDecode(response.body);

    if (data["err"] == null) {

      //Get instance SharedPrederences
      SharedPreferences sharedPreferences;
      sharedPreferences = await SharedPreferences.getInstance();

      //Save credentials with SharedPreferences
      sharedPreferences.setString("token", data["token"]);
      sharedPreferences.setString("commerce_id", data["id"]);
      sharedPreferences.setString("commerce_name", data["name"]);
      sharedPreferences.setString("commerce_email", data["email"]);

      //Return dont error
      return null;
    }

    //Return error
    return data['err'];
  }

  // Password reset
  Future resetPassword(String email) async {

  }

  // Sign out
  Future signOut() async {
    //Get token auth
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}
