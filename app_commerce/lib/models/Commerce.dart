class Commerce {
  //Attributes
  final String id;
  final String email;
  final String name;
  final String country;
  final String state;
  final double reputation;
  final String category;
  final String description;
  final String imageURL;
  final String publicId;

  //Constructor
  Commerce({
    this.id,
    this.email,
    this.name,
    this.country,
    this.state,
    this.reputation,
    this.category,
    this.description,
    this.imageURL,
    this.publicId,
  });

  //Deserialize Json to List<Product>
  factory Commerce.fromJson(Map<String, dynamic> parsedJson) {
    return Commerce(
      id: parsedJson['_id'],
      name: parsedJson['name'],
      email: parsedJson['email'],
      description: parsedJson['description'],
      country: parsedJson['country'],
      state: parsedJson['state'],
      category: parsedJson['category'],
      imageURL: parsedJson['imageURL'],
      publicId: parsedJson['public_id'],
    );
  }
}
