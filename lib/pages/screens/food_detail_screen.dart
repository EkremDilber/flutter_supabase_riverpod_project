import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_project/core/models/product_model.dart';
import 'package:flutter_supabase_project/core/provider/cart_provider.dart';
import 'package:flutter_supabase_project/core/utils/consts.dart';
import 'package:flutter_supabase_project/widgets/widgets.dart';
import 'package:readmore/readmore.dart';
import 'package:toastification/toastification.dart';

class FoodDetailScreen extends ConsumerStatefulWidget {
  final FoodModel product;
  const FoodDetailScreen({super.key, required this.product});

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appbarParts(context),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: size.width,
            height: size.height,
            color: imageBackground,
            child: Image.asset(
              "assets/food-delivery/food pattern.png",
              repeat: ImageRepeat.repeatY,
              color: imageBackGround2,
            ),
          ),
          Container(
            width: size.width,
            height: size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
          ),
          Container(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 90),
                  Center(
                    child: Hero(
                      tag: widget.product.imageCard,
                      child: Image.network(
                        widget.product.imageDetail,
                        height: 320,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      height: 45,
                      width: 120,
                      decoration: BoxDecoration(
                        color: red,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  quantity = quantity > 1 ? quantity - 1 : 1;
                                });
                              },
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              quantity.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.product.specialItems,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          children: [
                            const TextSpan(
                              text: "\$",
                              style: TextStyle(
                                fontSize: 14,
                                color: red,
                              ),
                            ),
                            TextSpan(
                              text: "${widget.product.price}",
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      foodInfo(
                        "assets/food-delivery/icon/star.png",
                        widget.product.rate.toString(),
                      ),
                      foodInfo(
                        "assets/food-delivery/icon/fire.png",
                        "${widget.product.rate.toString()} Kcal",
                      ),
                      foodInfo(
                        "assets/food-delivery/icon/time.png",
                        "${widget.product.rate.toString()} Min",
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ReadMoreText(
                    desc,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      height: 1.5,
                      color: Colors.black,
                    ),
                    trimLength: 110,
                    trimCollapsedText: "Read More",
                    trimExpandedText: "Collapse",
                    colorClickableText: red,
                    moreStyle:
                        TextStyle(fontWeight: FontWeight.bold, color: red),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () {},
          elevation: 0,
          backgroundColor: Colors.transparent,
          label: MaterialButton(
            onPressed: () async {
              await ref.read(cartProvider).addCart(
                  widget.product.name, widget.product.toMap(), quantity);
              /* showSnackBar(
              context,
              "${widget.product.name} added to cart!",
            ); */

              //Snackbar yerine "Toastification" gösteriyoruz
              showToastification(
                context,
                widget.product.name,
                "Added to cart",
                ToastificationType.success,
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            height: 65,
            color: red,
            minWidth: 350,
            child: const Text(
              "Add to Cart",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                letterSpacing: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row foodInfo(image, value) {
    return Row(
      children: [
        Image.asset(
          image,
          width: 25,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  AppBar appbarParts(BuildContext context) {
    return AppBar(
      title: Text(widget.product.name),
      backgroundColor: Colors.transparent,
      leadingWidth: 80,
      forceMaterialTransparency: true,
      actions: [
        const SizedBox(width: 27),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 18,
            ),
          ),
        ),
        const Spacer(),
        Container(
          height: 40,
          width: 40,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: const Icon(
            Icons.more_horiz_rounded,
            color: Colors.black,
            size: 18,
          ),
        ),
        const SizedBox(width: 27),
      ],
    );
  }
}
