import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _trailerUrlController = TextEditingController(); // Nuevo campo

  // Agregar película a Firestore
  Future<void> addMovieToFirestore(Map<String, dynamic> movie) async {
    try {
      await FirebaseFirestore.instance.collection('movies').add(movie);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Película agregada exitosamente')),
        );
      }

      clearFields(); // Limpia los campos del formulario
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar película: $e')),
        );
      }
    }
  }

  // Limpia los campos del formulario
  void clearFields() {
    _titleController.clear();
    _yearController.clear();
    _directorController.clear();
    _genreController.clear();
    _synopsisController.clear();
    _imageUrlController.clear();
    _trailerUrlController.clear(); // Limpia el nuevo campo
  }

  // Valida y envía la película a Firestore
  void addMovie() {
    if (_formKey.currentState?.validate() ?? false) {
      final newMovie = {
        "title": _titleController.text.trim(),
        "year": _yearController.text.trim(),
        "director": _directorController.text.trim(),
        "genre": _genreController.text.trim(),
        "synopsis": _synopsisController.text.trim(),
        "imageUrl": _imageUrlController.text.trim(),
        "trailerUrl": _trailerUrlController.text.trim(), // Nuevo campo añadido
      };
      addMovieToFirestore(newMovie);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administración de Películas')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth * 0.7;
          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: constraints.maxWidth > 600 ? maxWidth : double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Agregar Nueva Película',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Título'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Por favor ingresa un título.' : null,
                      ),
                      TextFormField(
                        controller: _yearController,
                        decoration: const InputDecoration(labelText: 'Año'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Por favor ingresa el año.' : null,
                      ),
                      TextFormField(
                        controller: _directorController,
                        decoration: const InputDecoration(labelText: 'Director'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Por favor ingresa el nombre del director.' : null,
                      ),
                      TextFormField(
                        controller: _genreController,
                        decoration: const InputDecoration(labelText: 'Género'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Por favor ingresa el género.' : null,
                      ),
                      TextFormField(
                        controller: _synopsisController,
                        decoration: const InputDecoration(labelText: 'Sinopsis'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Por favor ingresa la sinopsis.' : null,
                      ),
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Por favor ingresa la URL de la imagen.' : null,
                      ),
                      TextFormField(
                        controller: _trailerUrlController, // Nuevo campo
                        decoration: const InputDecoration(labelText: 'URL del Trailer'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Por favor ingresa la URL del trailer.' : null,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: addMovie,
                          child: const Text('Agregar Película'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _directorController.dispose();
    _genreController.dispose();
    _synopsisController.dispose();
    _imageUrlController.dispose();
    _trailerUrlController.dispose(); // Liberar el nuevo controlador
    super.dispose();
  }
}
