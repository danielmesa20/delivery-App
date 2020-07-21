class User {

  final int id;
  final String email;
  final String name;

  //Constructor
  User({this.id, this.email, this.name});

   factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as int,
      email: json["email"] as String,
      name: json["name"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };

}
