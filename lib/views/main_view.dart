import 'package:flutter/material.dart';
import 'list_view.dart'; // Importamos el catálogo para ir allí al pulsar el botón

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color crema = Color(0xFFFFF8E7);
    const Color dorado = Color(0xFFB8860B);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fotocolonia.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.4), // Oscurecemos la imagen para leer mejor
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cabecera
                  const Icon(Icons.spa, color: Colors.amberAccent, size: 50),
                  const SizedBox(height: 10),
                  const Text(
                    'Perfumería Bloom',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Fragancias elegantes para cada ocasión',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 50),

                  // Caja de bienvenida
                  Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      color: crema.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(2, 2)),
                      ],
                    ),
                    child: const Text(
                      'Bienvenido de nuevo.\n\nDescubre nuestra nueva colección de temporada con las mejores marcas internacionales.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // BOTÓN PARA IR AL CATÁLOGO
                  GestureDetector(
                    onTap: () {
                      // CAMBIO: Navegamos con push (para poder volver atrás si quisiéramos)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListViewPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      decoration: BoxDecoration(
                        color: dorado,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 5)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'VER CATÁLOGO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
