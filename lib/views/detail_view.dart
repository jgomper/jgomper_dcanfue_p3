import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'list_view.dart';
import 'cart_view.dart'; // IMPORTANTE: Importamos el carrito

class DetailView extends StatelessWidget {
  final Perfume perfume;

  const DetailView({Key? key, required this.perfume}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color dorado = Color(0xFFB8860B);
    const Color crema = Color(0xFFFFF8E7);

    return Scaffold(
      backgroundColor: crema,
      appBar: AppBar(
        title: Text(perfume.marca ?? 'Detalle'),
        backgroundColor: dorado,
        foregroundColor: Colors.white,
      ),
      // Botón Flotante para "Comprar" CONECTADO AL CARRITO REAL
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 1. AÑADIMOS EL PERFUME A LA LISTA
          CartView.carrito.add(perfume);

          // 2. Feedback al usuario (SnackBar con botón "Ver cesta")
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(child: Text('${perfume.nombre} añadido a la cesta')),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'VER CESTA',
                textColor: Colors.white,
                onPressed: () {
                   Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => const CartView())
                  );
                },
              ),
            ),
          );
        },
        backgroundColor: dorado,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.shopping_bag_outlined),
        label: const Text("Añadir al carrito"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Hero(
                tag: perfume.id,
                child: SizedBox(
                  height: 300,
                  child: CachedNetworkImage(
                    imageUrl: perfume.imagePath,
                    fit: BoxFit.contain, 
                    placeholder: (c, u) => const Center(child: CircularProgressIndicator(color: dorado)),
                    errorWidget: (c, u, e) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          perfume.nombre,
                          style: const TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D2D)
                          ),
                        ),
                      ),
                      Text(
                        perfume.precio,
                        style: const TextStyle(
                          fontSize: 24, 
                          color: dorado, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  Wrap(
                    spacing: 8,
                    children: [
                      if (perfume.concentracion != null)
                        Chip(
                          label: Text(perfume.concentracion!),
                          backgroundColor: Colors.white,
                          avatar: const Icon(Icons.opacity, size: 16, color: dorado),
                          side: const BorderSide(color: dorado),
                        ),
                      if (perfume.duracionHoras != null)
                         Chip(
                          label: Text("${perfume.duracionHoras}h duración"),
                          backgroundColor: Colors.white,
                          avatar: const Icon(Icons.access_time, size: 16, color: Colors.blueGrey),
                        ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  const Text("Descripción", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    perfume.descripcion, 
                    style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                  ),
                  
                  const SizedBox(height: 25),
                  if (perfume.notasOlfativas != null) ...[
                    const Text("Notas Olfativas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Text(
                        perfume.notasOlfativas!,
                        style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}