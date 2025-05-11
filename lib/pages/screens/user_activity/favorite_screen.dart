import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_project/core/models/product_model.dart';
import 'package:flutter_supabase_project/core/provider/favorite_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = supabase.auth.currentUser?.id;
    final provider = ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Favorites",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: userId == null
          ? const Center(
              child: Text("Please login to view favorites"),
            )
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase
                  .from("favorites")
                  .stream(primaryKey: ['id'])
                  .eq("user_id", userId)
                  .map((data) => data.cast<Map<String, dynamic>>()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final favorites = snapshot.data!;
                if (favorites.isEmpty) {
                  return const Center(
                    child: Text("No favorites yet"),
                  );
                }
                return FutureBuilder(
                  future: _fetchFavoriteItems(favorites),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final favoritesItems = snapshot.data!;
                    if (favoritesItems.isEmpty) {
                      return const Center(
                        child: Text("No favorites yet"),
                      );
                    }
                    return ListView.builder(
                      itemCount: favoritesItems.length,
                      itemBuilder: (context, index) {
                        final FoodModel items = favoritesItems[index];
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: NetworkImage(items.imageCard),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: Text(
                                              items.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                          Text(items.category),
                                          Text(
                                            "\$${items.price}.00",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.pink,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 50,
                              right: 35,
                              child: GestureDetector(
                                onTap: () {
                                  provider.toggleFavorite(items.name);
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 25,
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  Future<List<FoodModel>> _fetchFavoriteItems(
      List<Map<String, dynamic>> favorites) async {
    final List<String> productNames =
        favorites.map((fav) => fav['product_id'].toString()).toList();
    if (productNames.isEmpty) return [];

    try {
      final response = await supabase
          .from("food_product")
          .select()
          .inFilter('name', productNames);
      if (response.isEmpty) {
        return [];
      }
      return response.map((data) => FoodModel.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error fetching favorite items:$e');
      return [];
    }
  }
}
