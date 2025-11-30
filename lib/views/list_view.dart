import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'detail_view.dart';
import 'cart_view.dart'; // IMPORTANTE: Importamos el carrito

// --- MODELO --- 
class Perfume {
  final String id;
  final String nombre;
  final String descripcion;
  final String precio;
  final String imagePath;
  final bool isLocal;
  final String? marca;
  final String? notasOlfativas;
  final String? concentracion;
  final int? duracionHoras;

  Perfume({
    required this.id, required this.nombre, required this.descripcion,
    required this.precio, required this.imagePath, required this.isLocal,
    this.marca, this.notasOlfativas, this.concentracion, this.duracionHoras,
  });

  factory Perfume.fromJson(Map<String, dynamic> json) {
    return Perfume(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: json['precio'],
      imagePath: json['imagePath'],
      isLocal: json['isLocal'] ?? false,
      marca: json['marca'],
      notasOlfativas: json['notasOlfativas'],
      concentracion: json['concentracion'],
      duracionHoras: json['duracionHoras'],
    );
  }
}

// --- VISTA PRINCIPAL ---
class ListViewPage extends StatefulWidget {
  const ListViewPage({Key? key}) : super(key: key);

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  List<Perfume> _allPerfumes = [];
  List<Perfume> _filteredPerfumes = [];
  
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);
    
    final lista = (data['perfumes'] as List).map((i) => Perfume.fromJson(i)).toList();

    setState(() {
      _allPerfumes = lista;
      _filteredPerfumes = lista;
      _isLoading = false;
    });
  }

  void _filterPerfumes(String query) {
    final filtered = _allPerfumes.where((perfume) {
      final nameLower = perfume.nombre.toLowerCase();
      final brandLower = perfume.marca?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower) || brandLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredPerfumes = filtered;
    });
  }

  void _recargar() {
    setState(() {
      _isLoading = true;
      _searchController.clear();
    });
    _cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    const Color dorado = Color(0xFFB8860B);
    const Color crema = Color(0xFFFFF8E7);

    return Scaffold(
      backgroundColor: crema,
      appBar: AppBar(
        title: const Text('Colección Exclusiva'),
        backgroundColor: dorado,
        foregroundColor: Colors.white,
        actions: [
          // BOTÓN NUEVO: Ir al Carrito
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Ver mi cesta',
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const CartView())
              );
            },
          ),
          // Botón de refrescar
          IconButton(
            icon: const Icon(Icons.refresh), 
            onPressed: _recargar,
            tooltip: 'Recargar catálogo',
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: dorado))
        : Column(
            children: [
              // BARRA DE BÚSQUEDA
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterPerfumes,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o marca...',
                    prefixIcon: const Icon(Icons.search, color: dorado),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // LISTA DE RESULTADOS
              Expanded(
                child: _filteredPerfumes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.search_off, size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text("No se encontraron perfumes", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredPerfumes.length,
                      itemBuilder: (context, index) {
                        final perfume = _filteredPerfumes[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailView(perfume: perfume),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Hero(
                                  tag: perfume.id,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CachedNetworkImage(
                                        imageUrl: perfume.imagePath,
                                        fit: BoxFit.contain,
                                        placeholder: (c, u) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                        errorWidget: (c, u, e) => const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          perfume.marca?.toUpperCase() ?? '',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          perfume.nombre,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          perfume.precio,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: dorado,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Icon(Icons.chevron_right, color: Colors.grey),
                                ),
                              ],
                            ),
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
