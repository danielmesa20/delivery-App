import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  String local = 'http://192.168.250.7:4000';

  //Add New Product
  Future addProduct(Map product) async {
    //URL API
    var url = Uri.parse('$local/products/add');

    //API response
    var request = http.MultipartRequest('POST', url);

    //Get id commerce
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    //Send id commerce
    String id = sharedPreferences.getString("commerce_id");

    //Parameters to parse
    request.fields['name'] = product['name'];
    request.fields['price'] = product['price'];
    request.fields['description'] = product['description'];
    request.fields['available'] = product['available'];
    request.fields['commerce_id'] = id;

    //Open a byteStream
    //var stream = new http.ByteStream(DelegatingStream.typed(product['image'].openRead()));
    var stream = new http.ByteStream(product['image'].openRead());

    //Get file length
    var length = await product['image'].length();

    //Multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = new http.MultipartFile('myImage', stream, length,
        filename: basename(product['image'].path));

    //Add file to multipart
    request.files.add(multipartFile);

    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        return null;
      });
    }).catchError((e) {
      return e;
    });
  }

//Get Commerce Products
  Future getProducts() async {
    //Get id commerce
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    //Send id commerce
    String id = sharedPreferences.getString("commerce_id");

    //API URL
    String url = "$local/products/commerceProducts/$id";

    //API response
    var response = await http.get(url);

    //JSON to Map
    var data = jsonDecode(response.body);

    //Return result
    return data;
  }

//Update One Product
  Future updateProduct(Map product) async {
    //URL API
    var url = Uri.parse('$local/products/update');

    //API response
    var request = http.MultipartRequest('PUT', url);

    //Parameters to parse
    request.fields['id'] = product['id'];
    request.fields['name'] = product['name'];
    request.fields['price'] = product['price'];
    request.fields['description'] = product['description'];
    request.fields['available'] = product['available'];
    request.fields['imageURL'] = product['imageURL'];
    request.fields['public_id'] = product['public_id'];
    request.fields['commerce_id'] = product['commerce_id'];

    //Check Image exist
    if (product['image'] != null) {
      print("image exist");
      //Open a byteStream
      var stream = new http.ByteStream(product['image'].openRead());

      //Get file length
      var length = await product['image'].length();

      //Multipart that takes file.. here this "myImage" is a key of the API request
      var multipartFile = new http.MultipartFile('myImage', stream, length,
          filename: basename(product['image'].path));

      //Add file to multipart
      request.files.add(multipartFile);
    }

    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        return null;
      });
    }).catchError((e) {
      return e;
    });
  }

  //Get Commerce Products
  Future deleteProduct(String id) async {
   
    //API URL
    String url = "$local/products/delete/$id";

    //API response
    var response = await http.delete(url);

    //JSON to Map
    var data = jsonDecode(response.body);

    //Return result
    return data;
  }


}
