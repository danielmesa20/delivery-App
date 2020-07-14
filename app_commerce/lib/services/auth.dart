import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //Test url
  String local = 'http://192.168.250.8:4000';

  // SignUp
  Future signUp(Map commerce) async {
    //URL API
    var url = Uri.parse('$local/commerce/signupcommerce');

    //API response
    var request = http.MultipartRequest('POST', url);

    //Parameters to parse
    request.fields['name'] = commerce['name'];
    request.fields['password'] = commerce['password'];
    request.fields['email'] = commerce['email'];
    request.fields['category'] = commerce['category'];
    request.fields['country'] = commerce['country'];
    request.fields['state'] = commerce['state'];

    //Open a byteStream
    var stream = new http.ByteStream(commerce['image'].openRead());

    //Get file length
    var length = await commerce['image'].length();

    //Multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = new http.MultipartFile('myImage', stream, length,
        filename: basename(commerce['image'].path));

    //Add file to multipart
    request.files.add(multipartFile);

    //Check Internet Connection
    bool result = await DataConnectionChecker().hasConnection;

    if (result) {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return jsonDecode(response.body);
    } else {
      return {'err': 'Check your connection'};
    }
  }

  // Sign in with email & password
  Future signIn(String email, String password) async {
    //Commerce credentials
    Map credentials = {'email': email, 'password': password};

    //API URL
    String url = "$local/commerce/signincommerce";

    //Check Internet Connection
    bool result = await DataConnectionChecker().hasConnection;

    if (result) {
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
      }

      //Return data
      return data;
    } else {
      return {'err': 'Check your connection'};
    }
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
