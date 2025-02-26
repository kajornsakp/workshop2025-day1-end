import 'package:chopee/blocs/category_product/category_product_bloc.dart';
import 'package:chopee/blocs/category_product/category_product_events.dart';
import 'package:chopee/blocs/category_product/category_product_states.dart';
import 'package:chopee/buyer/components/product_card.dart';
import 'package:chopee/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;
  final IconData categoryIcon;

  const CategoryPage({
    super.key,
    this.categoryName = "Electronics",
    this.categoryIcon = Icons.devices,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryProductBloc>().add(CategoryProductsLoaded(widget.categoryName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: BlocBuilder<CategoryProductBloc, CategoryProductState>(
        builder: (context, state) {
          if (state is CategoryProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryProductsLoadFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load products: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CategoryProductBloc>().add(CategoryProductsLoaded(widget.categoryName));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is CategoryProductsLoadSuccess && 
                    state.categoryName.toLowerCase() == widget.categoryName.toLowerCase()) {
            final products = state.products;
            
            return products.isEmpty
                ? const Center(child: Text('No products found in this category'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
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
                  );
          }
          
          // Default case
          return const Center(child: Text('Select a category to view products'));
        },
      ),
    );
  }
}
