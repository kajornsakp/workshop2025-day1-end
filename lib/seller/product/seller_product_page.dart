import 'package:flutter/material.dart';
import 'package:chopee/router.dart';

class SellerProductsPage extends StatefulWidget {
  const SellerProductsPage({super.key});

  @override
  State<SellerProductsPage> createState() => _SellerProductsPageState();
}

class _SellerProductsPageState extends State<SellerProductsPage> {
  // Sample product data
  final List<Map<String, dynamic>> _products = List.generate(
    10,
    (index) => {
      'id': 'PROD${1000 + index}',
      'name': 'Product ${index + 1}',
      'price': (19.99 + index).toStringAsFixed(2),
      'stock': 10 + index * 5,
      'image': 'https://picsum.photos/200?random=$index',
      'active': true,
    },
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    context.navigateToSellerAddProduct();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        product['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                    ),
                    title: Text(product['name']),
                    subtitle: Text(
                      '\$${product['price']} • ${product['stock']} in stock',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: product['active'],
                          onChanged: (value) {
                            setState(() {
                              product['active'] = value;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            context.pushSellerEditProduct(product['id']);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      context.pushSellerEditProduct(product['id']);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
