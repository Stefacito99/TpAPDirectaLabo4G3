import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/drawer_menu.dart';
import 'package:flutter_app/widgets/custom_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'FlixFinder'),
      /*appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
        leadingWidth: 40,
        toolbarHeight: 60,
      ),*/
      drawer: DrawerMenu(),
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo_cine.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Contenido superpuesto
          const Center(
              /*child: Text(
              'Welcome to FlixFinder',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),*/
              ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
