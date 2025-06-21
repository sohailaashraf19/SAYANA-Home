import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/buyer/data/models/product_model.dart';
import 'package:my_house_design/feature/feature/buyer/data/repositories/buyer_search_repository.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyer_search_cubit.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyer_search_state.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/pdPage.dart';
import 'package:my_house_design/presentation/widgets/color.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (_) => BuyerSearchCubit(BuyerSearchRepository(Dio())),
      
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back , color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Search' , style: TextStyle(fontSize: 24, color: Colors.white)),
          backgroundColor: const Color(0xFF003664),
        ),
        body: const BuyerSearchWidget(),
      ),
    );
  }
}

class BuyerSearchWidget extends StatelessWidget {
  const BuyerSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search for products...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onChanged: (value) {
              BuyerSearchCubit.get(context).search(value);
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<BuyerSearchCubit, BuyerSearchState>(
            builder: (context, state) {
              if (state is BuyerSearchInitial) {
                return const Center(child: Text('Search Results'));
              } else if (state is BuyerSearchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BuyerSearchSuccess) {
                final products = state.results;

                if (products.isEmpty) {
                  return const Center(child: Text('No Results'));
                }

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              title: product.name,
                              price: product.price.toString(),
                              description: product.description,
                              imageUrl: product.imageUrl,
                              productId: product.id,
                            ),
                          ),
                        );
                      },
                      child: ProductCard(product: product),
                    );
                  },
                );
              } else if (state is BuyerSearchError) {
                return Center(child: Text('Error: ${state.message}\nPlease try again.'));
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: boxColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.network(
          product.imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
        ),
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Text('${product.price} EGP'),
      ),
    );
  }
}
