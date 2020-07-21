class Chat {
  //Attributes
  final String id;
  final String userID;
  final String commerceID;
  final String userName;
  final String commerceName;
  final String userURL;
  final String commerceURL;
  //Constructor
  Chat({
    this.id,
    this.userID,
    this.commerceID,
    this.userURL,
    this.commerceURL,
    this.userName,
    this.commerceName,
  });

  //Deserialize Json to List<Product>
  factory Chat.fromJson(Map<String, dynamic> parsedJson) {
    return Chat(
      id: parsedJson['_id'],
      userID: parsedJson['userID'],
      commerceID: parsedJson['commerceID'],
      userURL: parsedJson['userURL'],
      commerceURL: parsedJson['commerceURL'],
      userName: parsedJson['userName'],
      commerceName: parsedJson['commerceName'],
    );
  }
}
