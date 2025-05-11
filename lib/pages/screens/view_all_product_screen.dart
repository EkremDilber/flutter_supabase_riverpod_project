import 'package:flutter/material.dart';
import 'package:flutter_supabase_project/core/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/widgets.dart';

class ViewAllProductScreen extends StatefulWidget {
  const ViewAllProductScreen({super.key});

  @override
  State<ViewAllProductScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllProductScreen> {
  final supabase = Supabase.instance.client;
  List<FoodModel> products = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchFoodProduct();
  }

  // To fetch product data from Supabase
  Future<void> fetchFoodProduct() async {
    try {
      final response =
          await Supabase.instance.client.from('food_product').select();
      final data = response as List;

      setState(() {
        products = data.map((json) => FoodModel.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print("Error fetching food products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        leading: GeriButonu(),
        title: const Text(
          "All Products",
        ),
        backgroundColor: Colors.blue[50],
        forceMaterialTransparency: true,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.59,
                crossAxisSpacing: 8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductsItemsDisplay(
                  foodModel: products[index],
                );
              },
            ),
    );
  }
}
