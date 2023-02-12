import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/widgtes/widgets.dart';
import 'package:provider/provider.dart';

import '../services/servicies.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

   
  @override
  Widget build(BuildContext context) {

    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen:  false);

    if(productsService.isLoading) return const LoadingScreen(); 

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Productos', 
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {

            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
            
          }, 
          icon: const Icon(Icons.login_outlined)
        ),
      ),
    
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: (BuildContext context, int index) =>  GestureDetector(
          onTap: () {

            productsService.selectedProduct = productsService.products[index].copy();
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCard(
            product: productsService.products[index],
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {

          productsService.selectedProduct = Product(
            available: false, 
            name: '', 
            price: 0,
          );
          
          Navigator.pushNamed(context, 'product');
        },

      )
    );
  }
}