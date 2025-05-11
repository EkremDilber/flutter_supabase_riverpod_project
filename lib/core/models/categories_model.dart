// Assets klasörünün csv-files klasöründeki CSV dosyalarını Supabase'e yükleyebilirsiniz

// class Category {
//   String image, name;

//   Category({required this.image, required this.name});
// }

// List<Category> myCategories = [
//   Category(
//     image: 'assets/food-delivery/burger.png',
//     name: 'Burger',
//   ),
//   Category(
//     image: 'assets/food-delivery/pizza.png',
//     name: 'Pizza',
//   ),
//   Category(
//     image: 'assets/food-delivery/cup cake.png',
//     name: 'Cup Cake',
//   ),
// ];
//
// this is our category model where we have fetch data from supabse
class CategoryModel {
  String image, name;

  CategoryModel({required this.image, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(image: json['image'] ?? "", name: json['name'] ?? "");
  }
}
