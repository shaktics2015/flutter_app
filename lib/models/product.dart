class Product {
  final int id;
  final String title;
  final String writer;
  final String price;
  final String image;
  final String documentID;
  final String description =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum id neque libero. Donec finibus sem viverra, luctus nisi ac, semper enim. Vestibulum in mi feugiat, mattis erat suscipit, fermentum quam. Mauris non urna sed odio congue rhoncus. \nAliquam a dignissim ex. Suspendisse et sem porta, consequat dui et, placerat tortor. Sed elementum nunc a blandit euismod. Cras condimentum faucibus dolor. Etiam interdum egestas sagittis. Aliquam vitae molestie eros. Cras porta felis ac eros pellentesque, sed lobortis mi eleifend. Praesent ut.';
  int pages;
  double rating;

  Product(
      {this.price,
      this.rating,
      this.title,
      this.writer,
      this.id,
      this.image,
      this.pages,
      this.documentID});

  factory Product.fromJson(Map<String, dynamic> json) {
    return new Product(
        price: json['price'],
        rating: json['rating'],
        title: json['title'],
        writer: json['writer'],
        id: json['id'],
        image: json['image'],
        pages: json['pages'],
        documentID: json['documentID']);
  }

  toJson() {
    return {
      "price": price,
      "rating": rating,
      "title": title,
      "writer": writer,
      "id": id,
      "image": image,
      "pages": pages,
      "documentID": documentID
    };
  }
}
