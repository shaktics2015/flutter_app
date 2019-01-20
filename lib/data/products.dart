import '../models/product.dart';

final List<Product> products = [
  Product(price: 'Rp 50.000', rating: 3.5, title: 'CorelDraw untuk Tingkat Pemula Sampai Mahir', writer: 'Jubilee Enterprise', id: 1, image: 'assets/res/corel.jpg', pages: 123, documentID:"1"),
  Product(price: 'Rp 55.000', rating: 4.5, title: 'Buku Pintar Drafter Untuk Pemula Hingga Mahir', writer: 'Widada', id: 2, image: 'assets/res/drafter.jpg', pages: 200, documentID:"2"),
  Product(price: 'Rp 60.000', rating: 5.0, title: 'Adobe InDesign: Seri Panduan Terlengkap', writer:'Jubilee Enterprise', id: 3, image: 'assets/res/indesign.jpg', pages: 324, documentID:"3"),
  Product(price: 'Rp 58.000', rating: 3.0, title: 'Pemodelan Objek Dengan 3Ds Max 2014', writer: 'Wahana Komputer',  id: 4, image: 'assets/res/max_3d.jpeg', pages: 200, documentID:"4"),
  Product(price: 'Rp 90.000', rating: 4.8, title: 'Penerapan Visualisasi 3D Dengan Autodesk Maya', writer: 'Dhani Ariatmanto', id: 5, image: 'assets/res/maya.jpeg', pages: 234, documentID:"5"),
  Product(price: 'Rp 57.000', rating: 4.5, title: 'Teknik Lancar Menggunakan Adobe Photoshop', writer: 'Jubilee Enterprise', id: 6, image: 'assets/res/photoshop.jpg', pages: 240, documentID:"6"),
  Product(price: 'Rp 56.000', rating: 4.8, title: 'Adobe Premiere Terlengkap dan Termudah', writer: 'Jubilee Enterprise', id: 7, image: 'assets/res/premier.jpg', pages: 432, documentID:"7"),
  Product(price: 'Rp 55.000', rating: 4.5, title: 'Cad Series : Google Sketchup Untuk Desain 3D', writer: 'Wahana Komputer', id: 8, image: 'assets/res/sketchup.jpeg', pages: 321, documentID:"8"),
  Product(price: 'Rp 54.000', rating: 3.5, title: 'Webmaster Series : Trik Cepat Menguasai CSS', writer: 'Wahana Komputer',  id: 9, image: 'assets/res/webmaster.jpeg',pages: 431, documentID:"9"),
];

Future<List<Product>> getProducts() async {
  return products;
}
