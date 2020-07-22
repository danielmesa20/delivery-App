class Client {
  final int id;
  final String email;
  final String name;
  final String phone;
  final String country;
  final String state;

  //Constructor
  Client({
    this.id,
    this.email,
    this.name,
    this.phone,
    this.country,
    this.state,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
        id: json["id"] as int,
        email: json["email"] as String,
        name: json["name"] as String,
        phone: json['phone'] as String,
        country: json["country"] as String,
        state: json['state'] as String);
  }
}
