import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class DatabaseService {
  //Add New Product
  Future addProduct(Map product) async {
    //URL API
    var url = Uri.parse('http://192.168.250.7:4000/products/add');

    //API response
    var request = http.MultipartRequest('POST', url);

    //Parameters to parse
    request.fields['name'] = product['name'];
    request.fields['price'] = product['price'];
    request.fields['description'] = product['description'];
    request.fields['available'] = product['available'];
    request.fields['commerce_id'] = product['commerce_id'];

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
        print(value);
        return null;
      });
    }).catchError((e) {
      print(e);
      return null;
    });
  }
}

//Add New Product
Future addProductV2(Map product) async {

  //New DIO Object
  Dio dio = new Dio();

  //URL API
  var url = 'http://192.168.250.7:4000/products/add';

  //New FormData Object
  FormData formData = FormData.fromMap(<String, dynamic>{
    "name": product['name'],
    "price": product['price'],
    "description": product['description'],
    "available": product['available'],
    "commerce_id": product['commerce_id'],
    "myImage": await MultipartFile.fromFile(product['image'], filename: basename(product["image"].path))
  });

  //.path

  //API response
  var response = await dio.post(url,
      data: formData,
      options: Options(
          method: 'POST',
          responseType: ResponseType.json 
  ));

  print("Data v1" + response.data);
  var data = json.decode(response.data.toString());
  print("Data v2" + data);

  if(data['err'] == null){
    return null;
  }

  return data['err'] ;

}
