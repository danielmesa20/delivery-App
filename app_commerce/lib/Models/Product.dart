
class Product {
  //Attributes
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final bool available;
  final String imageURL;
  final String publicId;
  final String commerceId;

  //Constructor
  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.available,
    this.rating,
    this.imageURL,
    this.publicId,
    this.commerceId,
  });

  //Deserialize Json to List<Product>
  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    return Product(
      id: parsedJson['_id'],
      name: parsedJson['name'],
      description: parsedJson['description'],
      price: double.parse(parsedJson['price']),
      available: parsedJson['available'],
      rating: double.parse(parsedJson['rating']),
      imageURL: parsedJson['imageURL'],
      publicId: parsedJson['public_id'],
      commerceId: parsedJson['commerce_id'],
    );
  }
}