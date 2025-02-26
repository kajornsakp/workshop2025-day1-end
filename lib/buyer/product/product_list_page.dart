import 'package:chopee/blocs/category/category_bloc.dart';
import 'package:chopee/blocs/category/category_events.dart';
import 'package:chopee/blocs/category/category_states.dart';
import 'package:chopee/blocs/product/product_bloc.dart';
import 'package:chopee/blocs/product/product_events.dart';
import 'package:chopee/blocs/product/product_states.dart';
import 'package:chopee/buyer/components/product_card.dart';
import 'package:chopee/model/category.dart';
import 'package:chopee/model/product.dart';
import 'package:chopee/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:chopee/main.dart'; // To access the authReadyCompleter

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
    _waitForAuthAndLoadData();
  }

  Future<void> _waitForAuthAndLoadData() async {
    try {
      // Wait for authentication to be ready
      await authReadyCompleter.future;
    
      // Dispatch events to load data
      context.read<ProductBloc>().add(const ProductsLoaded());
      context.read<CategoryBloc>().add(const CategoriesLoaded());
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // Get states from both blocs
        final productState = context.watch<ProductBloc>().state;
        final categoryState = context.watch<CategoryBloc>().state;
        
        // Determine loading state
        final bool isLoading = 
            productState is ProductsLoading || 
            categoryState is CategoriesLoading;
        
        // Determine error state
        String? errorMessage;
        if (productState is ProductsLoadFailure) {
          errorMessage = productState.message;
        } else if (categoryState is CategoriesLoadFailure) {
          errorMessage = categoryState.message;
        }
        
        // Get products and categories from state
        final products = productState is ProductsLoadSuccess 
            ? productState.products 
            : [];
            
        final categories = categoryState is CategoriesLoadSuccess 
            ? categoryState.categories 
            : [];
        
        // Build UI based on state
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _waitForAuthAndLoadData,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Categories",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 120,
                            child: categories.isEmpty
                                ? const Center(child: Text("No categories available"))
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categories.length,
                                    itemBuilder: (context, index) {
                                      final category = categories[index];
                                      return GestureDetector(
                                        onTap: () {
                                          context.pushCategory(category.name);
                                        },
                                        child: Container(
                                          width: 100,
                                          margin: const EdgeInsets.only(right: 8, top: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.category, size: 40),
                                              const SizedBox(height: 8),
                                              Text(
                                                category.name,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Featured Products",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to all products
                                },
                                child: const Text("See All"),
                              ),
                            ],
                          ),
                          products.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text("No products available"),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    return ProductCard(
                                      product: product,
                                      onTap: () {
                                        if (product.id != null) {
                                          context.pushProduct(product.id!);
                                        }
                                      },
                                    );
                                  },
                                ),
                        ],
                      ),
          ),
        );
      },
    );
  }
}
