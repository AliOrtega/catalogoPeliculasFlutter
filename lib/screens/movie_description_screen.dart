import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:logger/logger.dart';

class MovieDescriptionScreen extends StatefulWidget {
  const MovieDescriptionScreen({super.key});

  @override
  MovieDescriptionScreenState createState() => MovieDescriptionScreenState();
}

class MovieDescriptionScreenState extends State<MovieDescriptionScreen> {
  YoutubePlayerController? _youtubeController;
  final Logger _logger = Logger();

  // Función para eliminar una película
  Future<void> deleteMovie(String movieId) async {
    try {
      await FirebaseFirestore.instance.collection('movies').doc(movieId).delete();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película eliminada exitosamente')),
      );
      
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la película: $e')),
      );
      _logger.e('Error al eliminar película: $e');
    }
  }

  // Función para editar una película
  Future<void> editMovie(String movieId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance.collection('movies').doc(movieId).update(updatedData);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película actualizada exitosamente')),
      );
      
      if (mounted) {
        setState(() {}); // Refrescar la pantalla solo si el widget está montado
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la película: $e')),
      );
      _logger.e('Error al actualizar película: $e');
    }
  }

  // Mostrar diálogo para editar la película
  void showEditDialog(Map<String, dynamic> movie, String movieId) {
    final TextEditingController titleController = TextEditingController(text: movie['title']);
    final TextEditingController yearController = TextEditingController(text: movie['year']);
    final TextEditingController directorController = TextEditingController(text: movie['director']);
    final TextEditingController genreController = TextEditingController(text: movie['genre']);
    final TextEditingController synopsisController = TextEditingController(text: movie['synopsis']);
    final TextEditingController imageUrlController = TextEditingController(text: movie['imageUrl']);
    final TextEditingController trailerUrlController = TextEditingController(text: movie['trailerUrl'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Película'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: yearController,
                  decoration: const InputDecoration(labelText: 'Año'),
                ),
                TextField(
                  controller: directorController,
                  decoration: const InputDecoration(labelText: 'Director'),
                ),
                TextField(
                  controller: genreController,
                  decoration: const InputDecoration(labelText: 'Género (separar por comas)'),
                ),
                TextField(
                  controller: synopsisController,
                  decoration: const InputDecoration(labelText: 'Sinopsis'),
                  maxLines: 3,
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                ),
                TextField(
                  controller: trailerUrlController,
                  decoration: const InputDecoration(labelText: 'URL del Tráiler (YouTube)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final updatedMovie = {
                  'title': titleController.text.trim(),
                  'year': yearController.text.trim(),
                  'director': directorController.text.trim(),
                  'genre': genreController.text.trim(),
                  'synopsis': synopsisController.text.trim(),
                  'imageUrl': imageUrlController.text.trim(),
                  if (trailerUrlController.text.isNotEmpty) 
                    'trailerUrl': trailerUrlController.text.trim(),
                };
                editMovie(movieId, updatedMovie);
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic>? movie =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String? trailerUrl = movie?['trailerUrl'];
    final String? youtubeVideoId =
        trailerUrl != null ? YoutubePlayer.convertUrlToId(trailerUrl) : null;

    if (youtubeVideoId != null && _youtubeController == null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: youtubeVideoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      )..addListener(() {
          if (_youtubeController?.value.isReady == false &&
              _youtubeController?.value.errorCode != 0) {
            _logger.e(
                'Error al reproducir el video: ${_youtubeController?.value.errorCode}');
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    
    // Verificar si los argumentos son válidos
    if (args == null || args is! Map<String, dynamic>) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Datos de la película no válidos')),
      );
    }

    final Map<String, dynamic> movie = args;
    final String? documentId = movie['documentId']; // ID del documento Firestore
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title'] ?? 'Descripción de la Película'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (documentId != null) {
                showEditDialog(movie, documentId);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No se encontró el ID del documento')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              if (documentId != null) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirmar eliminación'),
                    content: const Text('¿Estás seguro de que quieres eliminar esta película?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          deleteMovie(documentId);
                          Navigator.pop(context);
                        },
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No se encontró el ID del documento')),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: screenWidth * 0.9,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (movie['imageUrl'] != null)
                  Center(
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(movie['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  movie['title'] ?? 'Sin título',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 20,
                  children: [
                    _buildInfoItem('Año', movie['year']),
                    _buildInfoItem('Director', movie['director']),
                    _buildInfoItem('Género', movie['genre']),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sinopsis:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie['synopsis'] ?? 'No hay sinopsis disponible.',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                if (_youtubeController != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tráiler:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                      ),
                    ],
                  )
                else if (movie['trailerUrl'] != null && movie['trailerUrl'].toString().isNotEmpty)
                  const Text(
                    'Tráiler: URL proporcionada pero no válida',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value ?? 'Desconocido',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }
}