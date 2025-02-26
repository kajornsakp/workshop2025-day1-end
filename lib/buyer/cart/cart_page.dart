import 'package:chopee/blocs/cart/cart_bloc.dart';
import 'package:chopee/blocs/cart/cart_events.dart';
import 'package:chopee/blocs/cart/cart_states.dart';
import 'package:chopee/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(const CartLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: SafeArea(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading || state is CartInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartLoadFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Failed to load cart: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<CartBloc>().add(const CartLoaded()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is CartLoadSuccess) {
              final cart = state.cart;
              return _buildCartContent(context, cart);
            } else if (state is CartUpdating) {
              // Show updating UI with the current cart data
              return Stack(
                children: [
                  _buildCartContent(context, state.currentCart),
                  const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              );
            }
            
            // Fallback
            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, Cart cart) {
    if (cart.items.isEmpty) {
      return const Center(child: Text('Your cart is empty'));
    }
    
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.network(
                    item.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image, size: 60),
                  ),
                  title: Text(item.name),
                  subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (item.quantity > 1) {
                            context.read<CartBloc>().add(
                                CartItemUpdated(item.productId, item.quantity - 1));
                          } else {
                            context.read<CartBloc>().add(
                                CartItemRemoved(item.productId));
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                              CartItemUpdated(item.productId, item.quantity + 1));
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Total items: ${cart.totalItems}'),
              Text('Total: \$${cart.totalPrice.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to checkout or implement checkout logic
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Proceed to Checkout'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
