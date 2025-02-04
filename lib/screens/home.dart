import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/contatos/listar-contatos.dart';
import 'package:flutter_application_1/screens/mapa.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App de contatos',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Logo IFPI
          Center(
            child: Image.asset(
              'ifpi.png',
              height: 200,
            ),
          ),
          const SizedBox(height: 20), // Reduced spacing
          // Grid de botões
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0, // Added vertical spacing between rows
                crossAxisSpacing: 16.0,
                childAspectRatio: 1.0, // Makes buttons square
                children: [
                  _buildMenuButton(
                    title: 'Contatos',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ListaContatosScreen()));
                    },
                  ),
                  _buildMenuButton(
                    title: 'Mapas',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapaScreen()));
                    },
                  ),
                  _buildMenuButton(
                    title: 'Extra',
                    onTap: () {
                      // Implementar funcionalidade extra
                    },
                  ),
                  _buildMenuButton(
                    title: 'Extra',
                    onTap: () {
                      // Implementar funcionalidade extra
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.amber,
      borderRadius: BorderRadius.zero, // Matched with InkWell radius
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
