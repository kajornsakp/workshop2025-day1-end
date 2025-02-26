import 'package:chopee/blocs/cart/cart_bloc.dart';
import 'package:chopee/blocs/cart/cart_events.dart';
import 'package:chopee/blocs/product_detail/product_detail_bloc.dart';
import 'package:chopee/blocs/product_detail/product_detail_events.dart';
import 'package:chopee/blocs/product_detail/product_detail_states.dart';
import 'package:chopee/model/cart_item.dart';
import 'package:chopee/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({
    super.key, 
    required this.productId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductDetailBloc>().add(ProductDetailLoaded(widget.productId));
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.navigateToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handleBack(context),
        ),
        title: const Text('Product Details'),
      ),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductDetailLoadFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load product details: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductDetailBloc>().add(ProductDetailLoaded(widget.productId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is ProductDetailLoadSuccess) {
            final product = state.product;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                      child: product.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Center(
                                child: Icon(Icons.image, size: 100, color: Colors.grey),
                              ),
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.image, size: 100, color: Colors.grey),
                          ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Product Title
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Price
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Description
                    const Text(
                      'Product Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description ?? 'No description available',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Stock information
                    if (product.stock != null) ...[
                      Text(
                        'In Stock: ${product.stock}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Action buttons
                    Row(
                      children: [
                        IconButton(
                          onPressed: (){}, 
                          icon: const Icon(Icons.chat),
                          tooltip: 'Chat with seller',
                        ),
                        IconButton(
                          onPressed: () {
                            // Add to cart using BLoC
                            if (product.id != null) {
                              context.read<CartBloc>().add(
                                CartItemAdded(CartItem(productId: product.id!, quantity: 1))
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to cart')),
                              );
                            }
                          }, 
                          icon: const Icon(Icons.add_shopping_cart),
                          tooltip: 'Add to cart',
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            // Buy now functionality
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                          child: const Text('Buy Now'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          
          return const Center(child: Text('Select a product to view details'));
        },
      ),
    );
  }
}


